{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./apps/firefox
    ./apps/zsh
  ];

  home = {
    username = "cameron";
    homeDirectory = "/home/cameron";
    stateVersion = "25.05";
    packages = with pkgs; [
      # KDE Plasma
      kdePackages.kzones

      # Utilies and Tools
      orca-slicer
      kitty

      # Chat
      discord

      # Gaming
      steam
      lutris

      # Coding
      nixd
      alejandra
      vscode
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

  programs.vscode = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = 0.5;
    };
  };

  programs.git = {
    enable = true;
    userName = "Cameron Varley";
    userEmail = "cam.avarley@gmail.com";
  };
}
