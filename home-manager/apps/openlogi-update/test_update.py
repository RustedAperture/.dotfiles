import importlib.util
import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

SPEC = importlib.util.spec_from_file_location("update", Path(__file__).with_name("update.py"))
update = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(update)


class UpdateTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.repo = Path(self.directory.name)
        self.flake = self.repo / "flake.nix"
        self.lock = self.repo / "flake.lock"
        self.flake.write_text('url = "github:AprilNEA/OpenLogi/v0.9.0?dir=packaging";\n')
        self.lock.write_text('{"unchanged": true}\n')
        self.before = (self.flake.read_bytes(), self.lock.read_bytes())
        fake_nix = self.repo / "nix"
        fake_nix.write_text('''#!/usr/bin/env python3
import os, pathlib, sys
if os.environ.get("FAIL_NIX"):
    sys.exit(1)
path = pathlib.Path(sys.argv[-1].removeprefix("path:"))
(path / "flake.lock").write_text('{"updated": true}\\n')
if os.environ.get("EDIT_REPO"):
    pathlib.Path(os.environ["EDIT_REPO"]).write_text("user edit\\n")
''')
        fake_nix.chmod(0o755)
        self.environment = patch.dict(os.environ, {"PATH": f"{self.repo}:{os.environ['PATH']}"})
        self.environment.start()
        self.addCleanup(self.environment.stop)

    def test_updates_both_files(self):
        self.assertTrue(update.update(self.repo, "v0.10.0"))
        self.assertIn("/v0.10.0?dir=packaging", self.flake.read_text())
        self.assertEqual(json.loads(self.lock.read_text()), {"updated": True})

    def test_same_or_older_version_leaves_files_untouched(self):
        for tag in ["v0.9.0", "v0.8.0"]:
            self.assertFalse(update.update(self.repo, tag))
            self.assertEqual((self.flake.read_bytes(), self.lock.read_bytes()), self.before)

    def test_failed_lock_update_leaves_files_untouched(self):
        with patch.dict(os.environ, {"FAIL_NIX": "1"}):
            with self.assertRaises(Exception):
                update.update(self.repo, "v0.10.0")
        self.assertEqual((self.flake.read_bytes(), self.lock.read_bytes()), self.before)

    def test_concurrent_user_edit_is_preserved(self):
        with patch.dict(os.environ, {"EDIT_REPO": str(self.flake)}):
            with self.assertRaisesRegex(RuntimeError, "changed"):
                update.update(self.repo, "v0.10.0")
        self.assertEqual(self.flake.read_text(), "user edit\n")
        self.assertEqual(self.lock.read_bytes(), self.before[1])

    def test_rejects_invalid_release_tags(self):
        for tag in ["v1.0.0-rc1", "main", "../invalid"]:
            with self.assertRaises(ValueError):
                update.update(self.repo, tag)
        self.assertEqual((self.flake.read_bytes(), self.lock.read_bytes()), self.before)


if __name__ == "__main__":
    unittest.main()
