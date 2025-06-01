{ vscode-marketplace, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with vscode-marketplace; [
      zhuangtongfa.material-theme
    ];

    userSettings = {
      "workbench.colorTheme" = "One Dark Pro";
    };
  };
}
