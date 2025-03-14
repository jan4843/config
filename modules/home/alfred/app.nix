args:
let
  appPath = "/Applications/Alfred 5.app";
in
{
  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    alfred
  ];

  self.tcc = {
    Accessibility = [ appPath ];
    SystemPolicyAllFiles = [ appPath ];
  };

  self.open-at-login.alfred = {
    inherit appPath;
    preExec = ''
      wait4path ${args.lib.strings.escapeShellArg args.config.self.alfred.syncFolder}/Alfred.alfredpreferences
    '';
  };
}
