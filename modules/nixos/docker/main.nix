args: {
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "${args.config.self.persistence.path}/docker";
  };

  virtualisation.docker.autoPrune = {
    enable = true;
    dates = args.config.nix.gc.dates;
    flags = [
      "--all"
      "--volumes"
    ];
  };
}
