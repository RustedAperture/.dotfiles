{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./apps/firefox
    ./apps/zsh
    ./apps/vscode
    ./apps/dconf
    ./apps/xdg
  ];

  home = {
    username = "cameron";
    homeDirectory = "/home/cameron";
    stateVersion = "25.05";

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
      JAVA_HOME_11 = "${pkgs.zulu11}/lib/openjdk";
      NODE_HOME = "${pkgs.nodejs_20}/lib/node_modules";
    };

    packages = with pkgs; [
      # System Utilities
      alejandra
      bash
      bat
      btop
      eza
      fastfetch
      home-manager
      mission-center
      openssl
      winbox4

      # File Management & Screenshots
      baobab
      dconf-editor
      dconf2nix
      file-roller
      flameshot
      nautilus

      # Productivity & Time Management
      gnome-pomodoro
      refine
      tabiew
      taskwarrior3

      # Development Tools & Languages
      dart-sass
      nixd
      nodejs_20
      postman
      zulu11

      # IDEs & Editors
      godot
      jetbrains.idea-ultimate
      obsidian

      # Communication
      discord
      element-desktop

      # Gaming
      heroic
      lutris
      protonup-qt

      # Creative & 3D Printing
      orca-slicer

      # Music & Media
      tidal-hifi

      # Themes & Appearance
      qogir-icon-theme
    ];
  };

  services.flatpak = {
    update.onActivation = true;
    packages = [
      "com.bambulab.BambuStudio"
    ];
  };

  sops = {
    age.keyFile = "/home/cameron/.config/sops/age/keys.txt";

    defaultSopsFile = "/home/cameron/.dotfiles/secrets/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "cameron/private_key" = {
        path = "/home/cameron/.ssh/id_ed25519";
      };
      "cameron/public_key" = {
        path = "/home/cameron/.ssh/id_ed25519.pub";
      };
      "cameron/zipline" = {
        path = "/home/cameron/.config/zipline/token";
        mode = "0400";
      };
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      background-opacity = 0.9;
      font-family = [
        "Berkeley Mono"
        "FiraCode Nerd Font Mono"
      ];
      theme = "Monokai Pro";
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
      pride_month_disable = false;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
}
