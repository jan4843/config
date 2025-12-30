{ casks, ... }:
let
  appPath = "/Applications/Middle.app";
in
{
  ois.homebrew.casks = [ casks.middle ];

  homeConfig = {
    self.tcc.Accessibility = [ appPath ];

    self.open-at-login.middle.appPath = appPath;

    targets.darwin.defaults."com.knollsoft.Middle" = {
      trackpadFourTap = true;
      mouseTwoClick = true;
      hideMenuBarIcon = true;

      SUHasLaunchedBefore = true;
      SUEnableAutomaticChecks = false;
    };
  };
}
