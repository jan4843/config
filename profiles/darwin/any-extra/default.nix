{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/darwin/any-base")
  ];

  homeConfig.imports = [ (inputs.self + "/profiles/home/any-extra") ];
}
