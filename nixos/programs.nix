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
    };

    kdeconnect.enable = true;

    nix-ld = {
      enable = true;
    };

    steam = {
      enable = true;
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
