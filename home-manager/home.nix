{
  config,
  pkgs,
  lib,
  ...
}: let
  additionalJDKs = with pkgs; [temurin-bin-11 temurin-bin-17 jetbrains.jdk];
  hytale = pkgs.callPackage ../pkgs/hytale {inherit pkgs;};
in {
  imports = [
    ./apps/firefox
    ./apps/zsh
    ./apps/vscode
    ./apps/xdg
  ];

  home = {
    username = "cameron";
    homeDirectory = "/home/cameron";
    stateVersion = "25.05";

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
      NODE_HOME = "${pkgs.nodejs_20}/lib/node_modules";
    };

    sessionPath = ["${config.home.homeDirectory}/.jdks"];

    file = builtins.listToAttrs (builtins.map (jdk: {
        name = ".jdks/${jdk.version}";
        value = {
          source = jdk;
        };
      })
      additionalJDKs);

    packages = with pkgs; [
      # System Utilities
      alejandra
      bash
      bat
      btop
      eza
      flatpak
      fastfetch
      home-manager
      mission-center
      openssl

      # File Management & Screenshots
      baobab
      dconf-editor
      dconf2nix
      flameshot

      # Productivity & Time Management
      refine
      tabiew

      # Development Tools & Languages
      dart-sass
      nixd
      #nodejs_24
      yarn

      # IDEs & Editors
      godot
      obsidian

      # Communication
      discord
      element-desktop

      # Gaming
      heroic
      protonup-qt
      prismlauncher
      bs-manager

      # Music & Media
      obs-studio

      # Themes & Appearance
      qogir-icon-theme

      chromium
      #anydesk
      #calibre
      motrix-next
      protontricks
      kdePackages.filelight
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
      "openrouter/env" = {};
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
    settings = {
      user = {
        name = "Cameron Varley";
        email = "cam.avarley@gmail.com";
      };
    };
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

  home.activation.installHytale = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.flatpak}/bin/flatpak install --user --noninteractive --assumeyes ${hytale}/share/hytale/hytale-launcher-latest.flatpak || true
  '';
  services.kdeconnect.enable = true;
}
