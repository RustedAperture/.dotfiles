{
  config,
  pkgs,
  ...
}: let
  updater = pkgs.writeShellApplication {
    name = "update-openlogi";
    runtimeInputs = [pkgs.python3 pkgs.nix pkgs.libnotify];
    text = ''
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      exec python3 ${./update.py} ${pkgs.lib.escapeShellArg "${config.home.homeDirectory}/.dotfiles"}
    '';
  };
in {
  home.packages = [updater];

  systemd.user.services.openlogi-update = {
    Unit.Description = "Check for stable OpenLogi releases and update local Nix files";
    Service = {
      Type = "oneshot";
      ExecStart = "${updater}/bin/update-openlogi";
      TimeoutStartSec = "10min";
    };
  };

  systemd.user.timers.openlogi-update = {
    Unit.Description = "Check for OpenLogi updates daily";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
    Install.WantedBy = ["timers.target"];
  };
}
