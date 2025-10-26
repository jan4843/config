{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.keyboard-maestro ];
    };

  home-manager =
    { config, lib, ... }:
    let
      appPath = "/Applications/Keyboard Maestro.app";
      engineAppPath = "${appPath}/Contents/MacOS/Keyboard Maestro Engine.app";
      appPaths = [
        appPath
        engineAppPath
      ];
    in
    {
      self.open-at-login.keyboard-maestro = {
        appPath = engineAppPath;
      };

      self.tcc = {
        Accessibility = appPaths;
        SystemPolicyAllFiles = appPaths;
        ScreenCapture = appPaths;
        DeveloperTool = appPaths;
      };

      targets.darwin.defaults."com.stairways.keyboardmaestro.engine" = {
        StatusMenuDisplayType2 = "Alphabetical";
        ShowApplicationsPalette = false;
        StatusMenuIncludePaste = false;
        StatusMenuIncludeApplications = false;
      };

      targets.darwin.defaults."com.stairways.keyboardmaestro.editor" = {
        DisplayWelcomeWindow = false;
        SentContactInfo = true;
      };
    };
}
