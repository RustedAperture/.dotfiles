{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "hytale-launcher";
  version = "latest";

  src = ./hytale-launcher-latest.flatpak;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/hytale
    cp $src $out/share/hytale/hytale-launcher-latest.flatpak

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Hytale Launcher flatpak";
    platforms = platforms.linux;
  };
}
