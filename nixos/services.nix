{
  config,
  pkgs,
  ...
}: {
  services = {
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

    ipp-usb.enable = true;

    openssh = {
      enable = true;
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
      };
    };

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

    scx = {
      enable = false;
      scheduler = "scx_lavd";
    };

    udev = {
      packages = [
        pkgs.gnome-settings-daemon
        pkgs.game-devices-udev-rules
      ];
      extraRules = ''
        ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';
    };

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    avahi.enable = true;

    wivrn = {
      enable = true;
      openFirewall = true;

      # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
      # will automatically read this and work with WiVRn (Note: This does not currently
      # apply for games run in Valve's Proton)

      # Run WiVRn as a systemd service on startup
      autoStart = false;

      # You should use the default configuration (which is no configuration), as that works the best out of the box.
      # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
    };
  };
}
