let
  appPath = "/Applications/MonitorControl.app";
in
{
  self.homebrew.casks = [ "monitorcontrol" ];

  self.tcc.Accessibility = [ appPath ];

  self.open-at-login.monitorcontrol.appPath = appPath;

  targets.darwin.defaults."app.monitorcontrol.MonitorControl" = {
    multiKeyboardVolume = 2;
    menuIcon = 2;
    appAlreadyLaunched = true;

    SUHasLaunchedBefore = true;
    SUEnableAutomaticChecks = false;
  };
}
