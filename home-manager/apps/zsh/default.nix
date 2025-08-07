{...}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;

    initContent = ''
      source "/home/cameron/.dotfiles/home-manager/apps/zsh/.zshrc"
    '';
  };
}
