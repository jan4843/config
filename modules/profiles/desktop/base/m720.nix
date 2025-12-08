{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks."logi-options+" ];
    };

  home-manager = {
    self.tcc = {
      Accessibility = [
        "/Library/Application Support/Logitech.localized/LogiOptionsPlus/logioptionsplus_agent.app"
        "/Applications/Utilities/LogiPluginService.app"
      ];
      ListenEvent = [
        "/Library/Application Support/Logitech.localized/LogiOptionsPlus/logioptionsplus_agent.app"
      ];
    };
  };
}
