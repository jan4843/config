args: {
  networking.hostName = "vps1";
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";

  imports = with args.inputs.self.nixosModules; [
    default

    _server
    qemu-guest
  ];
}
