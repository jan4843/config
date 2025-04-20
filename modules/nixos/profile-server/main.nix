args: {
  time.timeZone = "CET";

  imports = with args.inputs.self.nixosModules; [
    home-manager
    persistence
    ssh-server
    tailscale
  ];
}
