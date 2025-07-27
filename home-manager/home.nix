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
      kdePackages.kzones
      orca-slicer
      kitty
    ];
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
}
