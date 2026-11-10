{
  config,
  pkgs,
  lib,
  ...
}: let
  desiredFlatpaks = [
    "com.bambulab.BambuStudio"
    "com.orcaslicer.OrcaSlicer"
  ];
  flatpakScript = pkgs.writeScript "flatpak-management" ''
    #!${pkgs.runtimeShell} -e
    ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Get currently installed Flatpaks
    installedFlatpaks=$(${pkgs.flatpak}/bin/flatpak list --app --columns=application)

    # Remove Flatpaks not in the desired list
    for installed in $installedFlatpaks; do
      if ! echo ${lib.concatStringsSep " " desiredFlatpaks} | grep -q "$installed"; then
        echo "Removing $installed because it's not in the desiredFlatpaks list."
        ${pkgs.flatpak}/bin/flatpak uninstall -y --noninteractive "$installed"
      fi
    done

    # Install or re-install desired Flatpaks
    for app in ${lib.concatStringsSep " " desiredFlatpaks}; do
      echo "Ensuring $app is installed."
      ${pkgs.flatpak}/bin/flatpak install -y --noninteractive flathub "$app"
    done

    # Remove unused Flatpaks
    ${pkgs.flatpak}/bin/flatpak uninstall --unused -y --noninteractive

    # Update all installed Flatpaks
    ${pkgs.flatpak}/bin/flatpak update -y --noninteractive
  '';
  # Installs the newest OrcaSlicer GitHub release (alpha/beta/rc, or a newer
  # stable) as the `master` branch next to Flathub's `stable` branch.
  orcaTestScript = pkgs.writeShellScript "orca-test-release" ''
    set -euo pipefail
    export PATH=${lib.makeBinPath [pkgs.curl pkgs.jq pkgs.flatpak pkgs.coreutils]}
    state=/var/lib/orca-test-release
    mkdir -p "$state"

    release=$(curl -fsSL "https://api.github.com/repos/OrcaSlicer/OrcaSlicer/releases?per_page=20" \
      | jq -c '[.[] | select(.tag_name != "nightly-builds" and (.draft | not))]
               | sort_by(.published_at) | last')
    tag=$(jq -r '.tag_name' <<<"$release")
    url=$(jq -r '.assets[] | select(.name | test("flatpak.*x86_64\\.flatpak$")) | .browser_download_url' <<<"$release" | head -n1)

    if [ -z "$url" ]; then
      echo "No x86_64 flatpak asset in $tag"; exit 1
    fi
    if [ "$(cat "$state/tag" 2>/dev/null)" = "$tag" ] \
       && flatpak info com.orcaslicer.OrcaSlicer//master >/dev/null 2>&1; then
      echo "OrcaSlicer $tag already installed"; exit 0
    fi

    echo "Installing OrcaSlicer $tag"
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    curl -fsSL "$url" -o "$tmp/orca.flatpak"
    flatpak install -y --noninteractive --reinstall --system --bundle "$tmp/orca.flatpak"
    flatpak make-current --system com.orcaslicer.OrcaSlicer master
    echo "$tag" > "$state/tag"
  '';
in {
  systemd.services.orca-test-release = {
    description = "Install newest OrcaSlicer test release";
    after = ["flatpak-management.service" "network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${orcaTestScript}";
    };
  };

  systemd.timers.orca-test-release = {
    description = "Check for new OrcaSlicer test releases";
    timerConfig = {
      OnCalendar = "daily";
      OnBootSec = "5min";
      Persistent = "true";
    };
    wantedBy = ["timers.target"];
  };

  systemd.services.flatpak-management = {
    description = "Manage Flatpak installations";
    stopIfChanged = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${flatpakScript}";
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.timers.flatpak-management = {
    description = "Run flatpak management periodically";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = "true";
    };
    wantedBy = ["timers.target"];
  };
}
