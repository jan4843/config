{ lib, ... }:
{
  options.self.alfred = {
    syncFolder = lib.mkOption {
      type = lib.types.path;
    };

    preferences = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
  };
}
