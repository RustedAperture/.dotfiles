{pkgs, ...}: {
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;

    flatpak = {
      enable = true;
    };

    fwupd.enable = true;

    gnome = {
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
    };

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
      extraConfig = ''
        DNS=1.1.1.1 8.8.8.8
        Domains=~.
      '';
    };

    udev = {
      packages = [pkgs.gnome-settings-daemon];
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
  };
}
