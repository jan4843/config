args: {
  homeConfig.imports = [ args.inputs.self.homeModules.docker ];

  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "${args.config.self.persistence.path}/docker";
  };

  virtualisation.docker.autoPrune = {
    enable = true;
    flags = [
      "--all"
      "--volumes"
    ];
  };
}
