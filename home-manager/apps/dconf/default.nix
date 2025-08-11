{
  pkgs,
  lib,
  ...
}: {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs; [
          gnomeExtensions.appindicator.extensionUuid
          gnomeExtensions.just-perfection.extensionUuid
          gnomeExtensions.dash-to-panel.extensionUuid
          gnomeExtensions.tiling-shell.extensionUuid
          gnomeExtensions.wallpaper-slideshow.extensionUuid
        ];
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Qogir-Dark";
        gtk-theme = "Adwaita";
        icon-theme = "Adwaita";
      };

      "org/gnome/mutter" = {
        experimental-features = [
          "scale-monitor-framebuffer"
          "variable-refresh-rate"
          "xwayland-native-scaling"
        ];
      };

      "org/gnome/shell/extensions/azwallpaper" = {
        slideshow-directory = "/home/cameron/.dotfiles/assets/wallpapers/32.9";
        lideshow-slide-duration = lib.hm.gvariant.mkTuple [0 15 0];
      };

      "org/gnome/shell/extensions/dash-to-panel" = {
        intellihide = true;
        primary-monitor = "SAM-HCSX300724";
        panel-anchors = ''
          {"SAM-HCSX300724":"MIDDLE"}
        '';
        panel-element-positions = ''
          {"SAM-HCSX300724":[{"element":"showAppsButton","visible":true,"position":"centered"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}
        '';
      };
    };
  };
}
