args: {
  imports = with args.inputs.self.nixosModules; [
    home-manager
    persistence
    ssh-server
    tailscale
  ];

  time.timeZone = "CET";

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      443
    ];
  };
}
