{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/base")
    (inputs.self + "/profiles/nixos/qemu-guest")
    (inputs.self + "/profiles/nixos/server")
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Thu 04:00";
}
