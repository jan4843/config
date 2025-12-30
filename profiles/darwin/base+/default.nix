{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/darwin/base")
  ];

  homeConfig.imports = [ (inputs.self + "/profiles/home/base+") ];
}
