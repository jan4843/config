let
  appPath = "/Applications/MonitorControl.app";
in
{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.monitorcontrol ];
    };

  home-manager =
    { config, ... }:
    {
      self.tcc.Accessibility = [ appPath ];

      self.open-at-login.monitorcontrol.appPath = appPath;

      targets.darwin.defaults."app.monitorcontrol.MonitorControl" = {
        multiKeyboardVolume = 2;
        menuIcon = 2;
        appAlreadyLaunched = true;

        SUHasLaunchedBefore = true;
        SUEnableAutomaticChecks = false;
      };
    };
}
