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
in {
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
