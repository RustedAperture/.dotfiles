{
  pkgs,
  config,
  ...
}: {
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      konsole
      krdp
      plasma-keyboard
      khelpcenter
      discover
    ];

    shells = with pkgs; [zsh];

    sessionVariables = {
      PROTON_FSR4_UPGRADE = 1;
      PROTON_FSR4_RDNA3_UPGRADE = 1;

      XDG_DATA_DIRS = [
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
        "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      ];
    };

    systemPackages = with pkgs; [
      gawk
      wget
      age
      sops
      cifs-utils
      dmidecode
      base16-schemes
      wl-clipboard
      jq
      wineWow64Packages.stable
      pv
      rsync
      kdePackages.bluedevil
      kdePackages.kinfocenter
      pciutils
      p7zip
      deskflow
      #wayvr
      #xrizer
      #monado
      pavucontrol
      btrfs-progs
    ];
  };
}
