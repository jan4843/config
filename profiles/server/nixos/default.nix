{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/base+")
    (inputs.self + "/profiles/personal")
  ];
}
