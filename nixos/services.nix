{
  config,
  pkgs,
  ...
}: {
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
  };

  services = {
    orca.enable = false;

    displayManager.cosmic-greeter = {
      enable = true;
    };
    desktopManager.plasma6.enable = true;

    libinput.enable = true;

    flatpak = {
      enable = true;
    };

    fwupd.enable = true;

    gvfs.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.extraConfig."99-disable-suspend" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "~alsa_input.*";
              }
              {
                "node.name" = "~alsa_output.*";
              }
            ];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
      };
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        epson-escpr
      ];
    };

    pulseaudio.enable = false;

    resolved = {
      enable = true;
    };

    scx-loader = {
      enable = false;
      config.default_sched = "scx_lavd";
    };

    udev = {
      packages = [
        pkgs.gnome-settings-daemon
        pkgs.game-devices-udev-rules
      ];
      extraRules = ''
        ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        # Vial keyboard configurator access
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        # Sofle Pico (VIA firmware) access for usevia.app
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="4a54", ATTRS{idProduct}=="5350", MODE="0660", GROUP="users", TAG+="uaccess"
      '';
    };

    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    avahi.enable = true;

  };
}
