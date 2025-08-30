{pkgs, ...}: {
  xdg = {
    desktopEntries = {
      "com.bambulab.BambuStudio" = {
        name = "Bambu Studio";
        comment = "3D printing software for Bambu Lab printers";
        icon = "com.bambulab.BambuStudio";
        exec = "flatpak run com.bambulab.BambuStudio %U";
        categories = ["Graphics" "3DGraphics"];
        mimeType = ["application/vnd.bambulab-bambustudio"];
        startupNotify = true;
        terminal = false;
      };
    };

    configFile = {
      "autostart/kitty.desktop".source = "${pkgs.kitty}/share/applications/kitty.desktop";
    };

    dataFile = {
      "icons/hicolor/48x48/apps/com.bambulab.BambuStudio.png".source = ../../../assets/icons/bambustudio-logo.png;
    };
  };
}
