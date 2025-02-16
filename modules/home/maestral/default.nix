{ lib, ... }:
{
  options.self.maestral = {
    syncFolder = lib.mkOption {
      type = lib.types.path;
    };
  };
}
