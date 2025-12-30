{ casks, ... }:
{
  ois.homebrew.casks = [ casks."logi-options+" ];

  homeConfig = {
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
