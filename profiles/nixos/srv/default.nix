{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/qemu-guest")
    (inputs.self + "/profiles/nixos/lan")
    (inputs.self + "/profiles/nixos/server")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
