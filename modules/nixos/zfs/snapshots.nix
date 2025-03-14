args: {
  services.sanoid = {
    enable = true;
    datasets = builtins.mapAttrs (
      name: value:
      value.snapshots
      // {
        autosnap = true;
        autoprune = true;
      }
    ) args.config.self.zfs.datasets;
  };
}
