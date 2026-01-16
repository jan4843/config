{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/pi4")
    (inputs.self + "/profiles/lan")
    (inputs.self + "/profiles/server")
  ];

  self.swap.sizeGB = 8;
}
