{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/any-base")
  ];

  homeConfig.imports = [
    (inputs.self + "/profiles/home/any-extra")
  ];
}
