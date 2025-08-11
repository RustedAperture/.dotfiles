{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  imports = [
    ./apps/firefox
    ./apps/zsh
    #./apps/hyprland
    ./apps/vscode
    ./apps/dconf
  ];

  home = {
    username = "cameron";
    homeDirectory = "/home/cameron";
    stateVersion = "25.05";

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
      JAVA_11_HOME = "${pkgs.jdk11}/lib/openjdk";
      NODE_HOME = "${pkgs.nodejs_20}/lib/node_modules";
    };

    packages = with pkgs; [
      # System / Core Utilities
      bash
      bat
      btop
      fastfetch
      mission-center
      openssl
      home-manager
      refine
      dconf-editor

      # Development Toolchains & Formatters
      jdk11
      nodejs_20
      dart-sass
      docker-compose
      nixd
      alejandra

      # IDEs / Editors / Knowledge
      pkgs-unstable.jetbrains.idea-ultimate
      godot
      obsidian
      podman-desktop

      # Browser
      chromium

      # Communication
      discord

      # Gaming
      lutris
      protonup-qt

      # Maker / 3D Printing
      orca-slicer

      # Music / Media
      tidal-hifi

      # Themes / Appearance
      qogir-icon-theme
    ];
  };

  sops = {
    age.keyFile = "/home/cameron/.config/sops/age/keys.txt";

    defaultSopsFile = "/home/cameron/.dotfiles/secrets/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/cameron" = {
        path = "/home/cameron/.ssh/id_ed25519";
      };
      "public_keys/cameron" = {
        path = "/home/cameron/.ssh/id_ed25519.pub";
      };
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      include = "/home/cameron/.dotfiles/assets/base16/base16-monokai-256.conf";
      background_opacity = 0.8;
      font_family = "Berkeley Mono";
      font_size = 12;
    };
  };

  programs.git = {
    enable = true;
    userName = "Cameron Varley";
    userEmail = "cam.avarley@gmail.com";
  };

  programs.hyfetch = {
    enable = true;
    settings = {
      backend = "fastfetch";
      preset = "pansexual";
      mode = "rgb";
      color_align = {
        mode = "horizontal";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita-dark";
  };
}
