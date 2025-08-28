{pkgs, ...}: {
  environment = {
    shells = with pkgs; [zsh];

    gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];

    systemPackages = with pkgs; [
      wget
      age
      sops
      gparted
      dmidecode
      base16-schemes
      ntfs3g
      steamcmd
      mangohud
      gnomeExtensions.appindicator
      gnomeExtensions.just-perfection
      gnomeExtensions.tiling-shell
      gnomeExtensions.wallpaper-slideshow
      gnomeExtensions.blur-my-shell
      gnomeExtensions.dash-to-dock
      gnomeExtensions.vitals
      gnomeExtensions.gdeej
      gnomeExtensions.mpris-label
      socat
      wl-clipboard
      jq
      vulkan-tools
      protontricks
      bottles-unwrapped
      wineWowPackages.stable
      mangojuice
    ];
  };
}
