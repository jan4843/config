{ config, ... }:
{
  services.sanoid = {
    enable = true;
    datasets = builtins.mapAttrs (
      name: value:
      value.snapshots
      // {
        autosnap = true;
        autoprune = true;
      }
    ) config.self.zfs.datasets;
  };
}
