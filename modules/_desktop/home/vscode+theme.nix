{ pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-marketplace; [
      zhuangtongfa.material-theme
    ];

    userSettings = {
      "workbench.colorTheme" = "One Dark Pro";
    };
  };
}
