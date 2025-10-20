{
  pkgs,
  lib,
  ...
}: let
  marketplace-extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "theme-monokai-pro-vscode";
      publisher = "monokai";
      version = "2.0.8";
      sha256 = "sha256-2ld3o8x/O+4DHWrfx3Hw8dDl9AX1CUY4MMi/35xRdkw=";
    }
    {
      name = "csv";
      publisher = "repreng";
      version = "1.2.2";
      sha256 = "sha256-8r19gcDOeixiMrS/dgg89RYrU2c48Hg6/ow4ejPA8mk=";
    }
  ];
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions;
        [
          geequlim.godot-tools
          jnoortheen.nix-ide
          kamadorueda.alejandra
          redhat.vscode-yaml
          signageos.signageos-vscode-sops
          rust-lang.rust-analyzer
          github.copilot
          github.copilot-chat
          esbenp.prettier-vscode
        ]
        ++ marketplace-extensions;

      userSettings = {
        "editor.fontFamily" = lib.mkForce "Berkeley Mono, FiraCode Nerd Font Mono";
        "editor.fontLigatures" = true;
        "editor.fontSize" = lib.mkForce 16;
        "editor.formatOnSave" = true;
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

        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
    };
  };
}
