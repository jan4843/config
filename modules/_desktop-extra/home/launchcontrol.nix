{
  self.homebrew.casks = [ "launchcontrol" ];

  self.tcc.SystemPolicyAllFiles = [ "/Applications/LaunchControl.app" ];

  targets.darwin.defaults."com.soma-zone.LaunchControl" = {
    SUHasLaunchedBefore = true;
    SUEnableAutomaticChecks = false;
  };
}
