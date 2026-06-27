{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    _base
    _qemu-guest
    _server
  ];

  networking.hostName = "vps1";
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Thu 04:00";

  fileSystems."/".fsType = "ext2";
}
