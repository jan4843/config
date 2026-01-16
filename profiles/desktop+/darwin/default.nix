{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/desktop")
    (inputs.self + "/profiles/base+")
  ];
}
