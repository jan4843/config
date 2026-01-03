{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/qemu-guest")
    (inputs.self + "/profiles/lan")
    (inputs.self + "/profiles/server")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
