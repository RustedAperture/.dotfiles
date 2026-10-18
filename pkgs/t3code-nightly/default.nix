# T3 Code nightly, run from a writable AppImage so the in-app updater works.
#
# electron-updater replaces the file at $APPIMAGE in place, which can't happen
# in the Nix store. Instead, the pinned AppImage below only seeds
# ~/.local/share/t3code-nightly on first launch; after that the app keeps
# itself up to date. Bumping `version`/`hash` only affects fresh installs
# (delete the seeded AppImage to force a reset to the pinned build).
{
  lib,
  fetchurl,
  appimageTools,
  appimage-run,
  writeShellApplication,
  symlinkJoin,
  codex,
  gh,
  git,
}: let
  pname = "t3code-nightly";
  version = "0.1.1-nightly.20261018.3315";

  # sha512 comes straight from the release's nightly-linux.yml.
  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha512-lPyn5IRXvK6q0Mli74oPc6SIOPCDDfZM9FgV2TyNn8+mX7im0bBJ6jwbKDLjZr/ZOPLuVKm1VXL1hit4YWkhlg==";
  };

  extracted = appimageTools.extract {inherit pname version src;};

  launcher = writeShellApplication {
    name = pname;
    runtimeInputs = [appimage-run codex gh git];
    text = ''
      dir="''${XDG_DATA_HOME:-$HOME/.local/share}/${pname}"
      # No version in the filename, so electron-updater overwrites it in place.
      app="$dir/T3-Code-Nightly.AppImage"

      if [ ! -e "$app" ]; then
        mkdir -p "$dir"
        install -m 755 ${src} "$app"
      fi

      exec appimage-run "$app" "$@"
    '';
  };
in
  symlinkJoin {
    inherit pname version;
    paths = [launcher];

    postBuild = ''
      for icon in ${extracted}/usr/share/icons/hicolor/*/apps/t3code.png; do
        size=$(basename "$(dirname "$(dirname "$icon")")")
        install -Dm644 "$icon" $out/share/icons/hicolor/$size/apps/${pname}.png
      done

      install -Dm644 ${extracted}/t3code.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail "Exec=AppRun" "Exec=${pname}" \
        --replace-fail "Icon=t3code" "Icon=${pname}"
    '';

    meta = {
      description = "T3 Code nightly (self-updating AppImage)";
      homepage = "https://github.com/pingdotgg/t3code";
      mainProgram = pname;
      platforms = ["x86_64-linux"];
    };
  }
