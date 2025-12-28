{ config, lib, ... }:
lib.mkIf (config.self.swap.sizeGB != 0) {
  swapDevices = [
    {
      device = "/nix/swapfile";
      size = config.self.swap.sizeGB * 1024;
    }
  ];
}
