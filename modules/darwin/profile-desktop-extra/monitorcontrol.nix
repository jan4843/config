{ casks, ... }:
let
  appPath = "/Applications/MonitorControl.app";
in
{
  ois.homebrew.casks = [ casks.monitorcontrol ];

  homeConfig = {
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
