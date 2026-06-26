{
  pkgs,
  config,
  ...
}: {
  environment = {
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
      gparted
      dmidecode
      base16-schemes
      mangohud
      socat
      wl-clipboard
      jq
      wineWow64Packages.stable
      mangojuice
      pv
      rsync
      kdePackages.bluedevil
      kdePackages.kzones
      kdePackages.kinfocenter
      pciutils
      p7zip
      deskflow
      proton-vpn
      wayvr
      android-tools
      xrizer
      kitty
      #monado
      winbox4
      pavucontrol
      btrfs-progs
      jstest-gtk
      ollama-rocm
      lmstudio
    ];
  };
}
