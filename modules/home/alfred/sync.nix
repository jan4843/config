{ config, lib, ... }:
lib.mkIf config.self.alfred.enable {
  targets.darwin.defaults."com.runningwithcrayons.Alfred-Preferences" = {
    syncfolder = config.self.alfred.syncFolder;
  };

  home.file."Library/Application Support/Alfred/prefs.json" = {
    force = true;
    text = lib.generators.toJSON { } {
      current = "${config.self.alfred.syncFolder}/Alfred.alfredpreferences";
      syncfolders."5" = config.self.alfred.syncFolder;
    };
  };
}
