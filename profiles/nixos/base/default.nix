{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    inputs.self.nixosModules.home-manager
    inputs.self.nixosModules.persistence
    inputs.self.nixosModules.swap
  ];

  homeConfig.imports = [
    (inputs.self + "/profiles/home/base")
  ];

  time.timeZone = "CET";
}
