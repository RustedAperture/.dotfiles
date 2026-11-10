{
  config,
  pkgs,
  lib,
  ...
}: let
  hytale = pkgs.callPackage ../pkgs/hytale {inherit pkgs;};
in {
  imports = [
    ./apps/firefox
    ./apps/openlogi-update
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
    };

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
      openssl
      ripgrep
      gh

      # File Management & Screenshots
      baobab

      # Development Tools & Languages
      nixd

      # IDEs & Editors
      obsidian
      t3code-nightly

      # Communication
      discord

      # Gaming
      heroic
      protonup-qt
      prismlauncher
      bs-manager

      # Themes & Appearance
      qogir-icon-theme

      #anydesk
      #calibre
      protontricks
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

  home.activation.installHytale = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.flatpak}/bin/flatpak install --user --noninteractive --assumeyes ${hytale}/share/hytale/hytale-launcher-latest.flatpak || true
    ${pkgs.flatpak}/bin/flatpak override --user --device=all com.hypixel.HytaleLauncher
  '';
}
