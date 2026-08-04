{ lib, ... }:
{
  programs.vscode.profiles.default = {
    userSettings = {
      "workbench.colorTheme" = lib.mkDefault "Dark Modern";
    };
  };
}
