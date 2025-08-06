{
  pkgs,
  lib,
  ...
}: let
  marketplaceExtensions = with pkgs.vscode-utils;
    extensionsFromVscodeMarketplace [
      {
        name = "theme-monokai-pro-vscode";
        publisher = "monokai";
        version = "2.0.7";
        sha256 = "sha256-MRFOtadoHlUbyRqm5xYmhuw0LL0qc++gR8g0HWnJJRE=";
      }
      {
        name = "fluent-icons";
        publisher = "miguelsolorio";
        version = "0.0.19";
        sha256 = "sha256-OfPSh0SapT+YOfi0cz3ep8hEhgCTHpjs1FfmgAyjN58=";
      }
    ];
in {
  home.packages = with pkgs; [
    dotnet-sdk
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions;
        [
          kamadorueda.alejandra
          jnoortheen.nix-ide
          signageos.signageos-vscode-sops
          vscode-icons-team.vscode-icons
          redhat.vscode-yaml
          github.copilot
          github.copilot-chat
          ms-dotnettools.csharp
          ms-dotnettools.vscode-dotnet-runtime
          ms-dotnettools.csdevkit
          ms-dotnettools.vscodeintellicode-csharp
        ]
        ++ marketplaceExtensions;

      userSettings = {
        "editor.fontFamily" = lib.mkForce "Berkeley Mono";
        "editor.fontSize" = lib.mkForce 16;
        "editor.fontLigatures" = true;
        "workbench.iconTheme" = "vscode-icons";
        "workbench.colorTheme" = lib.mkForce "Monokai Pro";
        "workbench.productIconTheme" = "fluent-icons";
        "nix.serverPath" = "nixd";
        "nix.enableLanguageServer" = true;
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [
                "alejandra"
              ];
            };
          };
        };
      };
    };
  };
}
