{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/pi4")
    (inputs.self + "/profiles/lan")
    (inputs.self + "/profiles/server")
  ];

  self.swap.sizeGB = 8;
}
