args: {
  networking.hostName = "sbc1";
  system.stateVersion = "24.11";

  homeConfig.home.username = "root";

  imports = with args.inputs.self.nixosModules; [
    default

    compose
    docker
    home-manager
    persistence
    pi4
    ssh-server
    tailscale
  ];

  networking.firewall.enable = false;
  zramSwap.enable = true;
}
