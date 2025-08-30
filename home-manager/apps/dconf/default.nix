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
          gnomeExtensions.dash-to-dock.extensionUuid
          gnomeExtensions.vitals.extensionUuid
          gnomeExtensions.gdeej.extensionUuid
          gnomeExtensions.mpris-label.extensionUuid
          gnomeExtensions.gsconnect.extensionUuid
        ];

        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "firefox.desktop"
          "discord.desktop"
          "steam.desktop"
        ];
      };

      "com/usebottles/bottles" = {
        show-sandbox-warning = false;
        steam-proton-support = true;
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
        slideshow-slide-duration = lib.hm.gvariant.mkTuple [0 15 0];
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
        close = ["<Super>q"];
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
        idle-delay = lib.hm.gvariant.mkUint32 900;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };

      "org/gnome/shell/extensions/gdeej" = {
        device-auto-detect = false;
        device-baud-rate = "9600";
        device-path = "/dev/ttyUSB0";
        serial-enabled = true;
      };

      "org/gnome/shell/extensions/vitals" = {
        alphabetize = true;
        fixed-widths = true;
        hide-icons = false;
        hot-sensors = [
          "_memory_usage_"
          "_processor_usage_"
          "_network_wifi_link quality_"
        ];
        icon-style = 1;
        include-static-info = false;
        menu-centered = false;
        position-in-panel = 2;
        show-system = true;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kitty";
        name = "Kitty";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>Delete";
        command = "/home/cameron/.dotfiles/assets/zipline-flameshot-file.sh";
        name = "Flameshot";
      };

      "org/gnome/shell/extensions/mpris-label" = {
        extension-place = "center";
        left-padding = 0;
        right-padding = 0;
      };

      "org/gnome/desktop/app-folders" = {
        folder-children = [
          "System Tools"
          "Programming"
          "Games"
        ];
      };

      "org/gnome/desktop/app-folders/folders/System Tools" = {
        apps = [
          "ca.desrt.dconf-editor.desktop"
          "org.gnome.Extensions.desktop"
          "org.gnome.Settings.desktop"
          "gparted.desktop"
          "page.tesk.Refine.desktop"
          "btop.desktop"
          "xterm.desktop"
          "cups.desktop"
          "io.missioncenter.MissionCenter.desktop"
          "kitty.desktop"
          "nixos-manual.desktop"
          "org.gnome.FileRoller.desktop"
        ];
        name = "System Tools";
        translate = false;
      };

      "org/gnome/desktop/app-folders/folders/Programming" = {
        apps = [
          "idea-ultimate.desktop"
          "org.godotengine.Godot4.4.desktop"
          "code.desktop"
        ];
        name = "Programming";
        translate = false;
      };

      "org/gnome/desktop/app-folders/folders/Games" = {
        apps = [
          "com.heroicgameslauncher.hgl.desktop"
          "net.lutris.Lutris.desktop"
          "io.github.radiolamp.mangojuice.desktop"
        ];
        name = "Games";
        translate = false;
      };
    };
  };

  home.activation.gdeejSliders = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/gdeej/sliders "[{'target': <uint16 0>, 'customApp': <\"\">, 'inverted': <true>, 'min': <uint16 0>, 'max': <uint16 1024>}, {'target': <uint16 4>, 'customApp': <\"Firefox\">, 'inverted': <true>, 'min': <uint16 0>, 'max': <uint16 1024>}, {'target': <uint16 4>, 'customApp': <\"Chromium\">, 'inverted': <true>, 'min': <uint16 0>, 'max': <uint16 1024>}, {'target': <uint16 3>, 'customApp': <\"Discord\">, 'inverted': <true>, 'min': <uint16 0>, 'max': <uint16 1024>}, {'target': <uint16 1>, 'customApp': <\"\">, 'inverted': <true>, 'min': <uint16 0>, 'max': <uint16 1024>}]"
  '';
}
