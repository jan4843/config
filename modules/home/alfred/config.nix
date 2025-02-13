{ config, ... }:
{
  self.alfred = {
    syncFolder = "${config.self.maestral.syncFolder}/Alfred";
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
