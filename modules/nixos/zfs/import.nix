args: {
  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs = {
    forceImportAll = true;
    extraPools = args.lib.pipe args.config.self.zfs.datasets [
      builtins.attrNames
      (map (x: builtins.head (builtins.split "/" x)))
      args.lib.unique
    ];
  };

  networking.hostId = args.lib.mkDefault "00000000";
}
