args: {
  networking.hostName = "vps1";
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";

  time.timeZone = "CET";
  zramSwap.enable = true;

  imports = with args.inputs.self.nixosModules; [
    default

    profile-server

    compose
    docker
    persistence
    qemu-guest
    ssh-server
    tailscale
  ];
}
