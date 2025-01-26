{
  config,
  lib,
  pkgs,
  ...
}:
let
  appPath = "/Applications/Hammerspoon.app";
in
{
  options.self.hammerspoon = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pkgs.hostPlatform.isDarwin && config.self.hammerspoon.spoons != { };
    };

    spoons = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };
  };

  config = lib.mkIf config.self.hammerspoon.enable {
    self.homebrew.casks = [ "homebrew/cask/hammerspoon" ];

    self.tcc.Accessibility = [ appPath ];

    self.open-at-login.hammerspoon.appPath = appPath;

    targets.darwin.defaults."org.hammerspoon.Hammerspoon" = {
      SUHasLaunchedBefore = true;
      SUEnableAutomaticChecks = false;
      MJShowMenuIconKey = false;
    };

    home.file.".hammerspoon" = {
      source = pkgs.runCommand ".hammerspoon" { } (
        lib.strings.concatLines (
          lib.attrsets.mapAttrsToList (name: lua: ''
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
          '') config.self.hammerspoon.spoons
        )
      );

      onChange = ''
        /usr/bin/open --background \
          -a ${lib.escapeShellArg appPath} \
          --url hammerspoon://reload_configuration
      '';
    };
  };
}
