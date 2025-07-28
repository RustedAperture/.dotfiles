{pkgs, ...}: {
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
        "editor.fontFamily" = "Berkeley Mono";
        "editor.fontSize" = 16;
        "editor.fontLigatures" = true;
        "workbench.iconTheme" = "vscode-icons";
        "workbench.colorTheme" = "Monokai Pro";
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
