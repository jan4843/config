args: {
  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    launchcontrol
  ];

  self.tcc.SystemPolicyAllFiles = [ "/Applications/LaunchControl.app" ];

  targets.darwin.defaults."com.soma-zone.LaunchControl" = {
    SUHasLaunchedBefore = true;
    SUEnableAutomaticChecks = false;
  };
}
