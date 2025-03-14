args: {
  targets.darwin.defaults."com.runningwithcrayons.Alfred-Preferences" = {
    syncfolder = args.config.self.alfred.syncFolder;
  };

  home.file."Library/Application Support/Alfred/prefs.json" = {
    force = true;
    text = args.lib.generators.toJSON { } {
      current = "${args.config.self.alfred.syncFolder}/Alfred.alfredpreferences";
      syncfolders."5" = args.config.self.alfred.syncFolder;
    };
  };
}
