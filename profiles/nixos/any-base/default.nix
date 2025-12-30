{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/modules/nixos/home-manager")
    (inputs.self + "/modules/nixos/persistence")
    (inputs.self + "/modules/nixos/swap")
  ];

  homeConfig.imports = [
    (inputs.self + "/profiles/home/any-base")
  ];

  time.timeZone = "CET";
}
