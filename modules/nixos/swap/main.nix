{ config, lib, ... }:
lib.mkIf (config.self.swap.sizeGB != 0) {
  swapDevices = lib.singleton {
    device = "/nix/swapfile";
    size = config.self.swap.sizeGB * 1024;
  };
}
