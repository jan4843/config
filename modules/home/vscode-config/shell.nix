{ lib, pkgs, ... }:
{
  self.vscode = {
    extensions = [ "timonwong.shellcheck" ];

    settings = {
      "[shellscript]" = {
        "editor.insertSpaces" = false;
      };

      "shellcheck.executablePath" = lib.getExe pkgs.shellcheck;
      "shellcheck.disableVersionCheck" = true;
    };
  };
}
