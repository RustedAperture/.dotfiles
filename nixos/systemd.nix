{
  config,
  pkgs,
  ...
}: let
  monitorsXmlContent = builtins.readFile ./monitors.xml;
in {
  systemd = {
    tmpfiles.rules = [
      ''
        f+ /run/gdm/.config/monitors.xml - gdm gdm - ${monitorsXmlContent}
      ''
    ];
  };
}
