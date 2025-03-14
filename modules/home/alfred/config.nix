args: {
  self.alfred = {
    syncFolder = "${args.config.self.maestral.syncFolder}/Alfred";
    preferences = {
      "features/clipboard" = {
        enabled = true;
      };
      "features/webbookmarks" = {
        indexSafari = true;
      };
    };
  };
}
