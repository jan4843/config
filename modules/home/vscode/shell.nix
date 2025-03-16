{ pkgs, vscode-marketplace, ... }@args:
{
  home.sessionVariables = rec {
    EDITOR = args.lib.mkOverride 800 "code --wait";
    VISUAL = EDITOR;
  };

  programs.vscode = {
    extensions = with vscode-marketplace; [
      timonwong.shellcheck
    ];

    userSettings = {
      "[shellscript]" = {
        "editor.insertSpaces" = false;
      };

      "shellcheck.executablePath" = "${pkgs.shellcheck}/bin/shellcheck";
      "shellcheck.disableVersionCheck" = true;
    };
  };
}
