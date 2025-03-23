args: {
  services.tailscale = {
    enable = true;
    extraDaemonFlags = [
      "--statedir=${args.config.self.persistence.path}/tailscale"
      "--state=${args.config.self.persistence.path}/tailscale/tailscaled.state"
    ];
  };

  self.freeform.caddy.ddns.ipSource = args.lib.mkBefore [
    "interface ${args.config.services.tailscale.interfaceName}"
  ];
}
