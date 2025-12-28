{ config, lib, ... }:
{
  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs = {
    forceImportAll = true;
    extraPools = lib.pipe config.self.zfs.datasets [
      builtins.attrNames
      (map (x: builtins.head (builtins.split "/" x)))
      lib.unique
    ];
  };

  networking.hostId = lib.mkDefault "00000000";

  services.zfs.autoScrub = {
    enable = true;
    interval = "Sun 04:00";
  };

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
