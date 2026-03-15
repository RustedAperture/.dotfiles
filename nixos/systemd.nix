{
  config,
  pkgs,
  ...
}: let
  monitorsXmlContent = builtins.readFile ./monitors.xml;
in {
  systemd = {
    user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    tmpfiles.rules = [
      ''
        f+ /run/gdm/.config/monitors.xml - gdm gdm - ${monitorsXmlContent}
      ''
    ];
  };
}
