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
  };

  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

  # Bootloader.
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride {mArch = "GENERIC_V3";};
  services.scx.enable = true;
  services.scx.scheduler = "scx_rusty";
  hardware.enableAllFirmware = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"
  ];

  security.polkit.enable = true;

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

  users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cameron = {
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

  security.sudo.extraRules = [
    {
      users = ["cameron"];
      commands = [
        {
          command = "/run/current-system/sw/bin/dmidecode";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld;

  # Install firefox.
  programs.firefox.enable = true;

  programs.git = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    extraCompatPackages = [
      pkgs.proton-cachyos
    ];
    gamescopeSession = {
      enable = true;
      steamArgs = [
        "-pipewire-dmabuf"
        "-tenfoot"
      ];
      args = [
        "--adaptive-sync"
        "--hdr-enabled"
        "--mangoapp"
        "--rt"
        "-e"
        "--steam"
      ];
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  chaotic.mesa-git.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment = {
    shells = with pkgs; [zsh];

    systemPackages = with pkgs; [
      wget
      age
      sops
      gparted
      dmidecode
      base16-schemes
      ntfs3g
      steamcmd
      mangohud
      fwupd
      docker-compose
      podman-compose
      gnomeExtensions.appindicator
      gnomeExtensions.just-perfection
      gnomeExtensions.tiling-shell
      gnomeExtensions.wallpaper-slideshow
      gnomeExtensions.blur-my-shell
      gnomeExtensions.gsconnect
      gnomeExtensions.dash-to-dock
      gnomeExtensions.vitals
      gnomeExtensions.gdeej
      nautilus
      file-roller
      socat
      wl-clipboard
      jq
      vulkan-tools
    ];
  };

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      berkeley-mono
    ];
  };

  virtualisation.docker.enable = false;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
