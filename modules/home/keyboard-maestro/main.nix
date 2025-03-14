args:
let
  syncFolder = "${args.config.self.maestral.syncFolder}/Keyboard Maestro";
  appPath = "/Applications/Keyboard Maestro.app";
  engineAppPath = "${appPath}/Contents/MacOS/Keyboard Maestro Engine.app";
in
{
  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    keyboard-maestro
  ];

  self.open-at-login.keyboard-maestro = {
    appPath = engineAppPath;
    preExec = ''
      wait4path ${args.lib.strings.escapeShellArg "${syncFolder}/Keyboard Maestro Macros.kmsync"}
    '';
  };

  self.tcc = rec {
    Accessibility = [
      appPath
      engineAppPath
    ];
    SystemPolicyAllFiles = Accessibility;
    ScreenCapture = Accessibility;
    DeveloperTool = Accessibility;
  };

  targets.darwin.defaults."com.stairways.keyboardmaestro.engine" = {
    StatusMenuDisplayType2 = "Alphabetical";
    ShowApplicationsPalette = false;
    StatusMenuIncludePaste = false;
    StatusMenuIncludeApplications = false;
  };

  targets.darwin.defaults."com.stairways.keyboardmaestro.editor" = {
    MacroSharingFile = "${syncFolder}/Keyboard Maestro Macros.kmsync";
    DisplayWelcomeWindow = false;
    SentContactInfo = true;
  };
}
