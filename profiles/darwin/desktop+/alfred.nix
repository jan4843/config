{ casks, homeConfig, ... }:
let
  appPath = "/Applications/Alfred 5.app";
in
{
  self.homebrew.casks = [ casks.alfred ];

  homeConfig = {
    self.tcc = {
      Accessibility = [ appPath ];
      SystemPolicyAllFiles = [ appPath ];
    };

    self.open-at-login.alfred = {
      inherit appPath;
    };

    self.backup.paths = [
      "${homeConfig.home.homeDirectory}/Library/Application Support/Alfred/Alfred.alfredpreferences"
      "${homeConfig.home.homeDirectory}/Library/Application Support/Alfred/powerpack.*"
      "${homeConfig.home.homeDirectory}/Library/Application Support/Alfred/prefs.json"
    ];
  };
}
