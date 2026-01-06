{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/desktop")
    (inputs.self + "/profiles/base+")
  ];
}
