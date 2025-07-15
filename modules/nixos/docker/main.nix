{ pkgs, ... }@args:
{
  homeConfig.imports = [ args.inputs.self.homeModules.docker ];

  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "${args.config.self.persistence.path}/docker";
  };

  systemd.services.docker-image-prune = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = args.lib.escapeShellArgs [
        "${pkgs.docker}/bin/docker"
        "image"
        "prune"
        "--all"
        "--force"
      ];
    };
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    startAt = "daily";
  };
}
