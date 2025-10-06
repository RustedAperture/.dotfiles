{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        userChrome = builtins.readFile ./userChrome.css;
        settings = {
          "browser.search.defaultEngine" = "DuckDuckGo";
          "browser.search.order.1" = "DuckDuckGo";
          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;
          "layers.acceleration.force-enabled" = true;
          "layout.css.backdrop-filter.enabled" = true;
          "sidebar.animation.enabled" = false;
          "svg.context-properties.content.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # WebGL settings
          "webgl.disabled" = false;
          "webgl.enable-debug-renderer-info" = true;
          "webgl.enable-webgl2" = true;
          "webgl.force-enabled" = true;
          "webgl.force-layers-readback" = false;
          "webgl.msaa-force" = true;
          "widget.wayland.fractional-scale.enabled" = true;
          "widget.windows.mica" = true;
          "widget.windows.mica.toplevel-backdrop" = 2;
        };
      };
    };
  };
}
