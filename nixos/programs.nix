{pkgs, ...}: {
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    gamemode.enable = true;

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
    };

    kdeconnect.enable = true;

    nix-ld = {
      enable = true;
    };

    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraProfile = ''
          # Fixes timezones on VRChat
          unset TZ
          # Allows Monado to be used
          export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
          export PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/wivrn/comp_ipc
        '';
      };
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      gamescopeSession = {
        enable = true;
        steamArgs = [
          "-pipewire-dmabuf"
          "-tenfoot"
        ];
        args = [
          "-r 120"
          "--expose-wayland"
          "--adaptive-sync"
          "--hdr-enabled"
          "--mangoapp"
          "--rt"
        ];
      };
    };

    zsh = {
      enable = true;
    };
  };
}
