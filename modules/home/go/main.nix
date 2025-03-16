{ pkgs, ... }@args:
let
  GOPATH = "${args.config.home.homeDirectory}/.local/go";
  GOROOT = "${pkgs.go}/share/go";
in
{
  home.packages = [ pkgs.go ];

  home.sessionVariables = {
    inherit GOPATH GOROOT;
  };

  programs.vscode = {
    extensions =
      with args.inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system}.vscode-marketplace; [
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
      "go.toolsManagement.go" = "${pkgs.go}/bin/go";

      "gopls" = {
        "ui.semanticTokens" = true;
      };
    };
  };
}
