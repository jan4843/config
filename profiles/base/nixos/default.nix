{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    ../common/hostname.nix
    ../common/nix.nix
    ../common/nixpkgs.nix
    inputs.self.nixosModules.home-manager
    inputs.self.nixosModules.persistence
    inputs.self.nixosModules.swap
  ];

  time.timeZone = "CET";
}
