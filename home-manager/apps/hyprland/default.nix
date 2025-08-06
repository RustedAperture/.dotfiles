{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./wallpaper.nix
  ];

  home.packages = with pkgs; [
    rofi-wayland
    rofi-bluetooth
    rofi-network-manager
    rofi-power-menu
    nwg-displays
    nwg-look
    swayosd
    fnott
    grimblast
    pavucontrol
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Blue-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  services.swayosd.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      source = "~/.config/hypr/monitors.conf";

      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
      ];

      exec-once = [
        "fnott"
        "systemctl --user start hyprpolkitagent"
      ];

      experimental = {
        xx_color_management_v4 = true;
      };

      general = {
        gaps_in = 8;
        gaps_out = 16;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "master";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "slave";
        mfact = 0.6;
        orientation = "center";
        slave_count_for_center_master = 2;
        drop_at_cursor = true;
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
        vrr = 1;
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      bind =
        [
          "$mod SHIFT, Q, exec, rofi -show p -modi p:'rofi-power-menu --symbols-font \"Symbols Nerd Font Mono\"' -font \"JetBrains Mono NF 16\" -theme Paper -theme-str 'window {width: 8em;} listview {lines: 6;}'"

          "$mod, T, exec, kitty"
          "$mod, D, exec, rofi -show drun"
          "$mod, W, exec, rofi-network-manager"
          "$mod, B, exec, rofi-bluetooth"
          "$mod, Q, killactive"

          "$mod, DELETE, exec, grimblast --notify copysave area ~/Pictures/screenshot_$(date +%s).png"

          # Move active window
          "$mod, LEFT, layoutmsg, swapprev"
          "$mod, RIGHT, layoutmsg, swapnext"
          "$mod, HOME, layoutmsg, swapwithmaster"

          "$mod, M, fullscreen, 1"
          "$mod, F, togglefloating"

          # Volume controls
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };
}
