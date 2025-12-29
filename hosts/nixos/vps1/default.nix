{ inputs, lib, ... }:
{
  imports =
    lib.self.siblingsOf ./default.nix
    ++ (with inputs.self.nixosModules; [
      profile-any-base
      profile-hardware-qemu
      profile-server
    ]);

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";

  self.autoupgrade.schedule = "Thu 04:00";
}
