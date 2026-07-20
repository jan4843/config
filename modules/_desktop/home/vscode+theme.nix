{ pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      github.github-vscode-theme
    ];

    userSettings = {
      "workbench.colorTheme" = "GitHub Dark Dimmed";
    };
  };
}
