{
  nixos =
    { config, lib, ... }:
    lib.mkIf (config.self.swap.sizeGB != 0) {
      zramSwap.enable = true;
    };
}
