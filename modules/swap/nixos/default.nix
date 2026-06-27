{ config, lib, ... }:
{
  options.self.swap = {
    sizeGB = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 0;
    };
  };

  config = lib.mkIf (config.self.swap.sizeGB != 0) {
    zramSwap.enable = true;

    swapDevices = lib.singleton {
      device = "/nix/swapfile";
      size = config.self.swap.sizeGB * 1024;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };
}
