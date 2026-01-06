{ config, ... }:
let
  appPath = "/Applications/Alfred 5.app";
in
{
  self.homebrew.casks = [ "alfred" ];

  self.tcc = {
    Accessibility = [ appPath ];
    SystemPolicyAllFiles = [ appPath ];
  };

  self.open-at-login.alfred = {
    inherit appPath;
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/Library/Application Support/Alfred/Alfred.alfredpreferences"
    "${config.home.homeDirectory}/Library/Application Support/Alfred/powerpack.*"
    "${config.home.homeDirectory}/Library/Application Support/Alfred/prefs.json"
  ];
}
