{...}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;

    shellAliases = {
      update = "sudo nixos-rebuild switch --flake /home/cameron/.dotfiles --upgrade";
      nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      home-clean = "home-manager expire-generations -d";
      nix-orphans = "nix store gc && sudo nix store optimise";
      nix-wipe = "sudo nix profile wipe-history";
      hm-clean-old = "home-manager remove-generations old";
      nix-sys-clean = "nix-clean && home-clean && nix-orphans && nix-wipe && hm-clean-old";
    };
  };
}
