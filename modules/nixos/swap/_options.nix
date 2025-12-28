{ lib, ... }:
{
  options.self.swap = {
    sizeGB = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 0;
    };
  };
}
