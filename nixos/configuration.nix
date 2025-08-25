{
  config,
  pkgs,
  inputs,
  ...
}: let
  berkeley-mono = pkgs.callPackage ../pkgs/berkeley-mono {inherit pkgs;};
  monitorsXmlContent = builtins.readFile ./monitors.xml;
  monitorsConfig = pkgs.writeText "gdm_monitors.xml" monitorsXmlContent;
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
      extra-substituters = [
        "https://chaotic-nyx.cachix.org"
      ];
      extra-trusted-public-keys = [
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];
    };

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./security.nix
    ./programs.nix
    ./environment.nix
  ];

  boot = {
    loader = {
      limine.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel = {
      sysctl = {
        "net.core.rmem_max" = 26214400;
        "net.core.wmem_max" = 26214400;
      };
    };

    kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride {mArch = "GENERIC_V3";};
  };

  networking = {
    hostName = "nixos";
    domain = "local";
    networkmanager.enable = true;
    useDHCP = false;
    useNetworkd = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
        45588
      ];
    };
  };

  systemd = {
    network = {
      networks = {
        "wlp8s0" = {
          name = "wlp8s0";
          DHCP = "ipv4";
          networkConfig = {
            MulticastDNS = true;
          };
        };
      };
    };
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

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"
  ];

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

  chaotic.mesa-git.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      berkeley-mono
    ];
  };

  virtualisation = {
    docker = {
      enable = false;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
