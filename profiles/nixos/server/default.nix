{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/any-extra")
  ];
}
