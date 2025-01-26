{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.self.plistbuddy = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          command = lib.mkOption {
            type = lib.types.str;
          };

          file = lib.mkOption {
            type = lib.types.path;
          };
        };
      }
    );
    default = [ ];
  };

  config = lib.mkIf pkgs.hostPlatform.isDarwin {
    self.scripts.write.plistbuddy.text = lib.concatMapStrings (x: ''
      /usr/libexec/PlistBuddy -c ${lib.escapeShellArg x.command} ${lib.escapeShellArg x.file} || :
    '') config.self.plistbuddy;
  };
}
