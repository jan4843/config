{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules."@base"
    inputs.self.nixosModules."@qemu-guest"
    inputs.self.nixosModules."@server"
  ];

  networking.hostName = "vps1";
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Thu 04:00";
}
