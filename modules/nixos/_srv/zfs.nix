args: {
  imports = [ args.inputs.self.nixosModules.zfs ];

  self.zfs.datasets = {
    "tank/archive".snapshots.daily = 99999999;
    "tank/backups".snapshots.daily = 7;
    "tank/media".snapshots.daily = 7;
  };
}
