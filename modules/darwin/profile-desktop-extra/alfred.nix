{ casks, config, ... }:
let
  appPath = "/Applications/Alfred 5.app";
in
{
  ois.homebrew.casks = [ casks.alfred ];

  homeConfig = {
    self.tcc = {
      Accessibility = [ appPath ];
      SystemPolicyAllFiles = [ appPath ];
    };

    self.open-at-login.alfred = {
      inherit appPath;
    };

    self.backup.paths = [
      "${config.homeConfig.home.homeDirectory}/Library/Application Support/Alfred/Alfred.alfredpreferences"
      "${config.homeConfig.home.homeDirectory}/Library/Application Support/Alfred/powerpack.*"
      "${config.homeConfig.home.homeDirectory}/Library/Application Support/Alfred/prefs.json"
    ];
  };
}
