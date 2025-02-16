{ config, lib, ... }:
let
  appPath = "/Applications/Maestral.app";
  cli = "${appPath}/Contents/MacOS/maestral-cli";
  path = lib.strings.escapeShellArg config.self.maestral.syncFolder;
in
{
  self.maestral.syncFolder = lib.mkDefault "${config.home.homeDirectory}/Library/Dropbox";

  self.homebrew.casks = [ "homebrew/cask/maestral" ];

  self.open-at-login.maestral = {
    inherit appPath;
    preExec = ''
      if [ "$(${cli} config get path)" != ${path} ]; then
        mkdir -p ${path}
        open -R ${path}
      fi
    '';
  };
}
