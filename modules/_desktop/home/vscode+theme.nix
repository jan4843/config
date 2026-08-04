{ pkgs, ... }:
{
  programs.vscode.profiles.default = {
    userSettings = {
      "workbench.colorTheme" = "Dark Modern";
    };
  };
}
