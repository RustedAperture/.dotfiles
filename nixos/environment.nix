{
  pkgs,
  config,
  ...
}: {
  environment = {
    shells = with pkgs; [zsh];

    sessionVariables = {
      PROTON_ENABLE_WAYLAND = 1;
      PROTON_ENABLE_HDR = 1;
    };

    systemPackages = with pkgs; [
      gawk
      wget
      age
      sops
      cifs-utils
      gparted
      dmidecode
      base16-schemes
      ntfs3g
      mangohud
      socat
      wl-clipboard
      jq
      wineWowPackages.stable
      mangojuice
      pv
      rsync
      kdePackages.bluedevil
      kdePackages.kzones
      kdePackages.kinfocenter
      pciutils
      p7zip
    ];
  };
}
