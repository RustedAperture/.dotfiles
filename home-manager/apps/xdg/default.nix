{
  pkgs,
  config,
  lib,
  ...
}: {
  xdg = {
    desktopEntries = {
      "org.gnome.baobab" = {
        name = "Baobab";
        genericName = "Disk Usage Analyzer";
        exec = "${lib.getExe pkgs.baobab} %U";
        icon = "org.gnome.baobab";
        categories = ["System" "Filesystem" "Utility"];
        mimeType = ["inode/directory"];
        startupNotify = true;
        terminal = false;
      };
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
      "autostart/com.mitchellh.ghostty.desktop".source = "${pkgs.ghostty}/share/applications/com.mitchellh.ghostty.desktop";
    };

    dataFile = {
      "icons/hicolor/48x48/apps/com.bambulab.BambuStudio.png".source = ../../../assets/icons/bambustudio-logo.png;
    };

    mimeApps.defaultApplications = {
      "inode/directory" = "nautilus.desktop";
    };
  };

  home.activation.setKdeTerminal = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${lib.getExe' pkgs.kdePackages.kconfig "kwriteconfig6"} --file kdeglobals --group General --key TerminalApplication ghostty
    run ${lib.getExe' pkgs.kdePackages.kconfig "kwriteconfig6"} --file kdeglobals --group General --key TerminalService com.mitchellh.ghostty.desktop
  '';
}
