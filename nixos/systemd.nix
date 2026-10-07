{
  config,
  pkgs,
  ...
}: let
  monitorsXmlContent = builtins.readFile ./monitors.xml;
in {
  systemd = {
    network = {
      enable = true;
      networks = {
        "20-ethernet" = {
          matchConfig.Name = "enp7s0";
          networkConfig = {
            DHCP = "yes";
            IPv6AcceptRA = true;
          };
          linkConfig.RequiredForOnline = "routable";
        };
      };
    };

    tmpfiles.rules = [
      ''
        f+ /run/gdm/.config/monitors.xml - gdm gdm - ${monitorsXmlContent}
      ''
    ];
  };
}
