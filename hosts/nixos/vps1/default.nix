{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/any-base")
    (inputs.self + "/profiles/nixos/hardware-qemu")
    (inputs.self + "/profiles/nixos/server")
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";

  self.autoupgrade.schedule = "Thu 04:00";
}
