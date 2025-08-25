{...}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;

    initContent = ''
      source "$HOME/.dotfiles/home-manager/apps/zsh/custom.zsh"
    '';
  };
}
