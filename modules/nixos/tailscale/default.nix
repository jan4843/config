{ config, ... }:
{
  services.tailscale = {
    enable = true;
    extraDaemonFlags = [
      "--no-logs-no-support"
      "--statedir=${config.self.persistence.path}/tailscale"
    ];
  };
}
