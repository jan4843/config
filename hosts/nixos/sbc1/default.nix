args: {
  networking.hostName = "sbc1";
  networking.domain = "jan.pm";

  system.stateVersion = "24.11";

  homeConfig.home.username = "root";

  imports = with args.inputs.self.nixosModules; [
    default

    caddy
    compose
    docker
    home-manager
    persistence
    pi4
    ssh-server
    tailscale
  ];

  zramSwap.enable = true;
}
