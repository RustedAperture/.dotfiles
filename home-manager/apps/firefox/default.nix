{...}: {
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        userChrome = builtins.readFile ./userChrome.css;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "widget.windows.mica" = true;
          "widget.windows.mica.toplevel-backdrop" = 2;
          "sidebar.animation.enabled" = false;
          "layers.acceleration.force-enabled" = true;
          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;
          "layout.css.backdrop-filter.enabled" = true;
        };
      };
    };
  };
}
