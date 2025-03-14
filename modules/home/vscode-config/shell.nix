{ pkgs, ... }:
{
  self.vscode = {
    extensions = [ "timonwong.shellcheck" ];

    settings = {
      "[shellscript]" = {
        "editor.insertSpaces" = false;
      };

      "shellcheck.executablePath" = "${pkgs.shellcheck}/bin/shellcheck";
      "shellcheck.disableVersionCheck" = true;
    };
  };
}
