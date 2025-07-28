{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "berkeley-mono";
  version = "2.002";

  src = ./250728540RJR6LN5.zip;

  unpackPhase = ''
    runHook preUnpack
    ${pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 250728540RJR6LN5/TX-02-YX9891Y8/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}
