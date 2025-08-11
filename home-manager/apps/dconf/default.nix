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
          gnomeExtensions.tiling-shell.extensionUuid
          gnomeExtensions.wallpaper-slideshow.extensionUuid
          gnomeExtensions.blur-my-shell.extensionUuid
          gnomeExtensions.gsconnect.extensionUuid
          gnomeExtensions.dash-to-dock.extensionUuid
          gnomeExtensions.vitals.extensionUuid
        ];

        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "firefox.desktop"
          "discord.desktop"
          "steam.desktop"
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

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        intellihide = false;
        intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
        hot-keys = false;
      };

      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        move-to-workspace-1 = ["<Shift><Super>1"];
        move-to-workspace-2 = ["<Shift><Super>2"];
        move-to-workspace-3 = ["<Shift><Super>3"];
        move-to-workspace-4 = ["<Shift><Super>4"];
      };

      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
      };

      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 0;
      };
    };
  };
}
