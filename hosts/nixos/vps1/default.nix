{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    profile-hardware-qemu
    profile-server
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";

  self.autoupgrade.schedule = "Thu 04:00";
}
