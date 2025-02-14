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
}
