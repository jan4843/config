{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    profiles.hardware.qemu
    profiles.server
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";

  self.autoupgrade.schedule = "Thu 04:00";
}
