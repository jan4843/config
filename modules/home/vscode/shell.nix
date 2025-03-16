{ pkgs, ... }@args:
{
  home.sessionVariables = rec {
    EDITOR = args.lib.mkOverride 800 "code --wait";
    VISUAL = EDITOR;
  };

  programs.vscode = {
    extensions =
      with args.inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system}.vscode-marketplace; [
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
