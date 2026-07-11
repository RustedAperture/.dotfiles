final: prev: let
  patchDir = ../patches/hdmi-frl-vrr;
  localVersionSuffix = "-frl-vrr";
  baseKernel = prev.linux_latest.override {
    modDirVersion = "${prev.linux_latest.version}${localVersionSuffix}";
  };
in {
  linuxPackages_hdmi_frl_vrr = prev.linuxPackagesFor (baseKernel.overrideAttrs (old: {
    # AMDGPU HDMI 2.1 Fixed Rate Link + VRR support, from
    # https://github.com/John-Gee/7-1-frl (a CachyOS kernel patch set).
    # hdmi_frl_amdnext.patch has two hunks that don't apply against vanilla
    # nixpkgs kernels (they assume CachyOS-only prerequisite code); those
    # hunks are stripped out here and replaced by 0003-nixos-frl-fixup.patch,
    # which reimplements the same change against the actual upstream source.
    patches =
      (old.patches or [])
      ++ [
        "${patchDir}/0001-fix-amd-color-manager.patch"
        "${patchDir}/0002-fix-dc-plane-cm-build-error.patch"
        "${patchDir}/hdmi_frl_amdnext-nixos.patch"
        "${patchDir}/hdmi_vrr_amdnext.patch"
        "${patchDir}/0003-nixos-frl-fixup.patch"
      ];

    # uname -r shows this suffix, since modDirVersion above must match it exactly.
    postPatch =
      (old.postPatch or "")
      + ''
        echo "${localVersionSuffix}" > localversion.20-frl-vrr
      '';
  }));
}
