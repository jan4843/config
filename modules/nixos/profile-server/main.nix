args: {
  imports = with args.inputs.self.nixosModules; [
    home-manager
    persistence
    ssh-server
    tailscale
  ];

  time.timeZone = "CET";

  zramSwap.enable = true;

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

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
