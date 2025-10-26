{
  nixos =
    { config, ... }:
    {
      services.tailscale = {
        enable = true;
        extraDaemonFlags = [
          "--statedir=${config.self.persistence.path}/tailscale"
          "--state=${config.self.persistence.path}/tailscale/tailscaled.state"
        ];
      };
    };
}
