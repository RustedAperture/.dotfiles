{
  lib,
  stdenvNoCC,
  patchelf,
  libGL,
  wayland,
  vulkan-loader,
  upstream,
}:
stdenvNoCC.mkDerivation {
  inherit (upstream) pname version meta;
  dontUnpack = true;
  # Upstream already ran fixup; another RPATH shrink would drop dlopen paths.
  dontFixup = true;
  nativeBuildInputs = [patchelf];

  # Reuse the upstream source build and its tests. The agent locates its
  # overlay beside its own executable, so keep all binaries in this output.
  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -a ${upstream}/. "$out/"
    chmod u+w "$out/bin/openlogi-overlay" "$out/share/systemd/user/openlogi-agent.service"

    # Upstream adds these dlopen paths to the desktop binary only. The
    # Actions Ring uses the same GPUI backend in a separate executable.
    patchelf --add-rpath "${lib.makeLibraryPath [libGL wayland vulkan-loader]}" \
      "$out/bin/openlogi-overlay"
    substituteInPlace "$out/share/systemd/user/openlogi-agent.service" \
      --replace-fail "${upstream}/bin/openlogi-agent" "$out/bin/openlogi-agent"
    runHook postInstall
  '';
}
