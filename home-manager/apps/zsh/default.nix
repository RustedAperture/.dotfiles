{config, ...}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;

    initContent = ''
      export OPENROUTER_API_KEY=$(cat ${config.sops.secrets."openrouter/env".path})
      source "$HOME/.dotfiles/home-manager/apps/zsh/custom.zsh"
    '';
  };
}
