args: {
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "${args.config.self.persistence.path}/docker";
  };
}
