{ config, ... }:
let
  appPath = "/Applications/Middle.app";
in
{
  self.homebrew.casks = with config.self.homebrew.taps."homebrew/cask".casks; [
    middle
  ];

  self.tcc.Accessibility = [ appPath ];

  self.open-at-login.middle.appPath = appPath;

  targets.darwin.defaults."com.knollsoft.Middle" = {
    trackpadFourTap = true;
    mouseTwoClick = true;
    hideMenuBarIcon = true;

    SUHasLaunchedBefore = true;
    SUEnableAutomaticChecks = false;
  };
}
