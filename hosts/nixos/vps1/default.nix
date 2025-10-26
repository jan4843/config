{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    profile-hardware-qemu
    profile-server
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";
}
