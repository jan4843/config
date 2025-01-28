{ lib, ... }:
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
}
