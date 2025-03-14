args: {
  imports = [ args.inputs.nixos-hardware.nixosModules.raspberry-pi-4 ];

  nixpkgs.hostPlatform = "aarch64-linux";
}
