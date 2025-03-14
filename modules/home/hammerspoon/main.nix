{ pkgs, ... }@args:
let
  appPath = "/Applications/Hammerspoon.app";
in
args.lib.mkIf (args.config.self.hammerspoon.spoons != { }) {
  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    hammerspoon
  ];

  self.tcc.Accessibility = [ appPath ];

  self.open-at-login.hammerspoon.appPath = appPath;

  targets.darwin.defaults."org.hammerspoon.Hammerspoon" = {
    SUHasLaunchedBefore = true;
    SUEnableAutomaticChecks = false;
    MJShowMenuIconKey = false;
  };

  home.file.".hammerspoon" = {
    source = pkgs.runCommand ".hammerspoon" { } (
      args.lib.strings.concatLines (
        args.lib.attrsets.mapAttrsToList (name: lua: ''
          mkdir -p $out/Spoons/${name}.spoon

          printf 'hs.loadSpoon("%s")\n' ${name} >> $out/init.lua

          cat <<EOF > $out/Spoons/${name}.spoon/init.lua
          local obj = {}
          obj.__index = obj
          function obj:init()
            dofile("${pkgs.writeText "${name}.lua" lua}")
          end
          return obj
          EOF
        '') args.config.self.hammerspoon.spoons
      )
    );

    onChange = ''
      /usr/bin/open --background \
        -a ${args.lib.escapeShellArg appPath} \
        --url hammerspoon://reload_configuration
    '';
  };
}
