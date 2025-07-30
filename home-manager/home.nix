{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./apps/firefox
    ./apps/zsh
    #./apps/kde
    ./apps/hyprland
    ./apps/vscode
  ];

  home = {
    username = "cameron";
    homeDirectory = "/home/cameron";
    stateVersion = "25.05";
    packages = with pkgs; [
      # Utilies and Tools
      orca-slicer
      kitty
      hyfetch
      fastfetch

      # Chat
      discord

      # Gaming
      steam
      lutris

      # Coding
      nixd
      alejandra
      vscode

      # Music
      tidal-hifi
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
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      include = "/home/cameron/.dotfiles/assets/base16/base16-monokai-256.conf";
      background_opacity = 0.8;
      font_family = "Berkeley Mono";
      font_size = 12;
      color_mode = "256";
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
}
