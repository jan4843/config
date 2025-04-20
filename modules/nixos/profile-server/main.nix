args: {
  imports = with args.inputs.self.nixosModules; [
    docker
    home-manager
    persistence
    ssh-server
    tailscale
  ];
}
