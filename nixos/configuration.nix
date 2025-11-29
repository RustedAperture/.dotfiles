{
  config,
  pkgs,
  inputs,
  ...
}: let
  berkeley-mono = pkgs.callPackage ../pkgs/berkeley-mono {inherit pkgs;};
in {
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };

    settings = {
      system-features = ["nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-x86-64-v3"];
      auto-optimise-store = true;
      trusted-users = ["root" "cameron" "@wheel"];
      download-buffer-size = 524288000;
    };

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./security.nix
    ./programs.nix
    ./environment.nix
    ./systemd.nix
    ./flatpak.nix
  ];

  boot = {
    loader = {
      limine.enable = true;
      efi.canTouchEfiVariables = true;
    };

    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom=CA
    '';

    kernel = {
      sysctl = {
        "net.core.rmem_max" = 26214400;
        "net.core.wmem_max" = 26214400;
      };
    };

    kernelPackages = pkgs.linuxPackages_lqx;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  sops = {
    defaultSopsFile = "/home/cameron/.dotfiles/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      "cameron/passwd" = {
        neededForUsers = true;
      };
      "wifi/env" = {};
    };
  };

  networking = {
    hostName = "nixos";
    domain = "local";

    networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [config.sops.secrets."wifi/env".path];
        profiles."home" = {
          connection = {
            id = "home";
            type = "wifi";
            autoconnect = true;
          };

          wifi = {
            mode = "infrastructure";
            ssid = "$WIFISSID";
            bssid = "$WIFIBSSID";
          };

          wifi-security = {
            key-mgmt = "sae";
            psk = "$WIFIPSK";
          };
        };
      };
    };

    firewall = {
      enable = true;
      allowedUDPPorts = [
        45588
      ];
    };
  };

  users = {
    mutableUsers = false;
    users.cameron = {
      isNormalUser = true;
      description = "Cameron";
      hashedPasswordFile = config.sops.secrets."cameron/passwd".path;
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "tty"
        "dialout"
        "uucp"
      ];
      shell = pkgs.zsh;
    };
  };

  nixpkgs.config.allowUnfree = true;

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      berkeley-mono
    ];
  };

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
