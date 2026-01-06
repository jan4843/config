{
  self.homebrew.casks = [ "logi-options+" ];

  self.tcc = {
    Accessibility = [
      "/Library/Application Support/Logitech.localized/LogiOptionsPlus/logioptionsplus_agent.app"
      "/Applications/Utilities/LogiPluginService.app"
    ];
    ListenEvent = [
      "/Library/Application Support/Logitech.localized/LogiOptionsPlus/logioptionsplus_agent.app"
    ];
  };
}
