{
  pkgs,
  lib,
  ...
}: let
  marketplace-extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "theme-monokai-pro-vscode";
      publisher = "monokai";
      version = "2.0.7";
      sha256 = "sha256-MRFOtadoHlUbyRqm5xYmhuw0LL0qc++gR8g0HWnJJRE=";
    }
    {
      name = "csv";
      publisher = "repreng";
      version = "1.2.2";
      sha256 = "sha256-8r19gcDOeixiMrS/dgg89RYrU2c48Hg6/ow4ejPA8mk=";
    }
  ];

  continue-extension = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "continue";
      publisher = "Continue";
      version = "1.2.2";
      sha256 = "sha256-xk2maMEa07yFPbLiDGc9N6AbzxjTyfVNy/k7wWSMOHE=";
      arch = "linux-x64";
    };
    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];
    buildInputs = [pkgs.stdenv.cc.cc.lib];
  };
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions;
        [
          geequlim.godot-tools
          jnoortheen.nix-ide
          kamadorueda.alejandra
          redhat.vscode-yaml
          signageos.signageos-vscode-sops
          rust-lang.rust-analyzer
        ]
        ++ marketplace-extensions
        ++ [continue-extension];

      userSettings = {
        "editor.fontFamily" = lib.mkForce [
          "Berkeley Mono"
          "FiraCode Nerd Font Mono"
        ];
        "editor.fontLigatures" = true;
        "editor.fontSize" = lib.mkForce 16;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [
                "alejandra"
              ];
            };
          };
        };

        "workbench.colorTheme" = lib.mkForce "Monokai Pro";
        "workbench.iconTheme" = "vscode-icons";
        "yaml.schemas" = {
          "file:///home/cameron/.vscode-oss/extensions/Continue.continue/config-yaml-schema.json" = [
            ".continue/**/*.yaml"
          ];
        };
      };
    };
  };
}
