{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "${config.self.persistence.path}/docker";
  };

  systemd.services.docker-image-prune = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.escapeShellArgs [
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

  homeConfig.imports = [
    (
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
    )
  ];
}
