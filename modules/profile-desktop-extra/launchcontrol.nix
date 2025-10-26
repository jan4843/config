{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.launchcontrol ];
    };

  home-manager = {
    self.tcc.SystemPolicyAllFiles = [ "/Applications/LaunchControl.app" ];

    targets.darwin.defaults."com.soma-zone.LaunchControl" = {
      SUHasLaunchedBefore = true;
      SUEnableAutomaticChecks = false;
    };
  };
}
