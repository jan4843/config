{ lib, pkgs, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-marketplace; [
      timonwong.shellcheck
    ];

    userSettings = {
      "shellcheck.executablePath" = lib.getExe pkgs.shellcheck;
      "shellcheck.disableVersionCheck" = true;
    };
  };
}
