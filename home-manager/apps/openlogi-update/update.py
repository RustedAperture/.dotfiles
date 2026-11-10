"""Update the OpenLogi release pin locally, without rebuilding or committing."""

import fcntl
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request


PIN = re.compile(rb"github:AprilNEA/OpenLogi/(v?\d+\.\d+\.\d+)\?dir=packaging")


def version(tag):
    if not re.fullmatch(r"v?\d+\.\d+\.\d+", tag):
        raise ValueError(f"Unexpected stable release tag: {tag!r}")
    return tuple(map(int, tag.removeprefix("v").split(".")))


def update(repo, tag):
    release = version(tag)
    paths = [repo / "flake.nix", repo / "flake.lock"]
    original = [path.read_bytes() for path in paths]
    matches = list(PIN.finditer(original[0]))
    if len(matches) != 1:
        raise RuntimeError("Expected exactly one OpenLogi release pin in flake.nix")
    match = matches[0]
    if release <= version(match[1].decode()):
        return False
    new_flake = original[0][:match.start(1)] + tag.encode() + original[0][match.end(1):]

    # Stage both files and resolve only this input before touching the checkout.
    # Keeping staging on the same filesystem allows atomic file replacements.
    with tempfile.TemporaryDirectory(prefix=".openlogi-update-", dir=repo) as directory:
        staging = Path(directory)
        for path in paths:
            shutil.copy2(path, staging / path.name)
        (staging / "flake.nix").write_bytes(new_flake)
        subprocess.run(
            ["nix", "flake", "update", "openlogi", "--flake", f"path:{staging}"],
            check=True, timeout=300,
        )
        if [path.read_bytes() for path in paths] != original:
            raise RuntimeError("Checkout changed during update; leaving user edits untouched")
        os.replace(staging / "flake.nix", paths[0])
        try:
            os.replace(staging / "flake.lock", paths[1])
        except OSError:
            paths[0].write_bytes(original[0])
            raise
    return True


def notify(title, body):
    # KDE's notification server may not be available outside a desktop session.
    try:
        subprocess.run(
            ["notify-send", "--app-name=OpenLogi updater", "--icon=software-update-available", title, body],
            check=True, timeout=15,
        )
    except (OSError, subprocess.SubprocessError) as error:
        print(f"Notification unavailable: {error}", file=sys.stderr)


def main():
    repo = Path(sys.argv[1]).resolve()
    runtime = Path(os.environ["XDG_RUNTIME_DIR"])
    with (runtime / "openlogi-update.lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        try:
            request = urllib.request.Request(
                "https://api.github.com/repos/AprilNEA/OpenLogi/releases/latest",
                headers={"Accept": "application/vnd.github+json", "User-Agent": "openlogi-local-updater"},
            )
            with urllib.request.urlopen(request, timeout=30) as response:
                release = json.load(response)
            if release.get("draft") or release.get("prerelease"):
                raise ValueError("GitHub returned a non-stable release")
            tag = release["tag_name"]
            if update(repo, tag):
                message = f"Updated local files to {tag}. Rebuild NixOS when ready."
                print(message)
                notify("OpenLogi update ready", message)
            else:
                print(f"OpenLogi is already at {tag} or newer.")
        except Exception as error:
            notify("OpenLogi update failed", f"Files were not updated: {error}")
            raise


if __name__ == "__main__":
    main()
