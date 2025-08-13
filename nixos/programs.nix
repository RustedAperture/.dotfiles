{pkgs, ...}: {
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    git = {
      enable = true;
    };

    nix-ld = {
      enable = true;
      package = pkgs.nix-ld;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [
        pkgs.proton-cachyos
      ];
      gamescopeSession = {
        enable = true;
        steamArgs = [
          "-pipewire-dmabuf"
          "-tenfoot"
        ];
        args = [
          "--adaptive-sync"
          "--hdr-enabled"
          "--mangoapp"
          "--rt"
          "-e"
          "--steam"
        ];
      };
    };

    zsh = {
      enable = true;
    };
  };
}
