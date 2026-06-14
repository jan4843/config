{ config, lib, ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "${config.self.persistence.path}/docker";
  };

  systemd.services.docker-image-prune = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.escapeShellArgs [
        "${config.virtualisation.docker.package}/bin/docker"
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

  homeConfig.imports = lib.singleton (
    { config, ... }:
    {
      self.backup = {
        paths = [
          config.home.homeDirectory
        ];
        exclude = [
          "${config.home.homeDirectory}/.*"
          "${config.home.homeDirectory}/*/cache"
        ];
      };
    }
  );
}
