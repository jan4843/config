{ vscode-marketplace, ... }:
{
  programs.vscode = {
    extensions = with vscode-marketplace; [
      zhuangtongfa.material-theme
    ];

    userSettings = {
      "workbench.colorTheme" = "One Dark Pro";
    };
  };
}
