{ pkgs, ... }@args:
{
  programs.vscode = {
    extensions =
      with args.inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system}.vscode-marketplace; [
        zhuangtongfa.material-theme
      ];

    userSettings = {
      "workbench.colorTheme" = "One Dark Pro";
    };
  };
}
