args:
let
  appPath = "/Applications/Maestral.app";
  cli = "${appPath}/Contents/MacOS/maestral-cli";
  path = args.lib.strings.escapeShellArg args.config.self.maestral.syncFolder;
in
{
  self.maestral.syncFolder = args.lib.mkDefault "${args.config.home.homeDirectory}/Library/Dropbox";

  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    maestral
  ];

  self.open-at-login.maestral = {
    inherit appPath;
    preExec = ''
      if [ "$(${cli} config get path)" != ${path} ]; then
        mkdir -p ${path}
        open -R ${path}
      fi
    '';
  };
}
