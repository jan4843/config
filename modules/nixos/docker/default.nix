{ config, ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "${config.self.persistence.path}/docker";
  };
}
