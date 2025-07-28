{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        kamadorueda.alejandra
        jnoortheen.nix-ide
        signageos.signageos-vscode-sops
        vscode-icons-team.vscode-icons
        redhat.vscode-yaml
        github.copilot
        github.copilot-chat
      ];
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
