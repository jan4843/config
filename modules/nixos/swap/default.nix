{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  options.self.swap = {
    sizeGB = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 0;
    };
  };

  config = lib.mkIf (config.self.swap.sizeGB != 0) {
    swapDevices = lib.singleton {
      device = "/nix/swapfile";
      size = config.self.swap.sizeGB * 1024;
    };
  };
}
