{...}: {
  home.file.".mozilla/firefox/default/chrome" = {
    source = "${builtins.fetchGit {
      url = "https://github.com/RustedAperture/gwfox-css";
      rev = "main";
    }}/chrome";
    recursive = true;
  };

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "widget.windows.mica" = true;
          "widget.windows.mica.toplevel-backdrop" = 2;
          "sidebar.animation.enabled" = false;
        };
      };
    };
  };
}
