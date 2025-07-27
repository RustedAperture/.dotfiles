{
  config,
  pkgs,
  ...
}: {
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

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;

    shellAliases = {
      update = "sudo nixos-rebuild switch --flake /home/cameron/.dotfiles --upgrade";
    };
  };

  programs.vscode = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = 0.8;
    };
  };
}
