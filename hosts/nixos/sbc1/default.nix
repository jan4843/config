args: {
  networking.hostName = "sbc1";

  system.stateVersion = "24.11";

  homeConfig.home.username = "root";

  imports = with args.inputs.self.nixosModules; [
    default

    profile-server

    caddy
    compose
    docker
    home-manager
    persistence
    pi4
    sonos-joiner
    ssh-server
    tailscale
  ];

  zramSwap.enable = true;
}
