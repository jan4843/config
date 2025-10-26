{
  home-manager =
    {
      config,
      lib,
      pkgs,
      vscode-marketplace,
      ...
    }:
    let
      GOPATH = "${config.home.homeDirectory}/.local/go";
      GOROOT = "${pkgs.go}/share/go";
    in
    {
      home.packages = with pkgs; [
        go
        graphviz
      ];

      home.sessionVariables = {
        inherit GOPATH GOROOT;
      };

      programs.vscode.profiles.default = {
        extensions = with vscode-marketplace; [
          golang.go
        ];

        userSettings = {
          "[go]" = {
            "editor.formatOnSave" = true;
          };

          "go.gopath" = GOPATH;
          "go.goroot" = GOROOT;
          "go.showWelcome" = false;
          "go.survey.prompt" = false;
          "go.toolsManagement.autoUpdate" = true;
          "go.toolsManagement.go" = lib.getExe pkgs.go;

          "gopls" = {
            "ui.semanticTokens" = true;
          };
        };
      };
    };
}
