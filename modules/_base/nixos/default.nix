{ inputs, ... }:
{
  imports = [
    ../common/hostname.nix
    ../common/nix.nix
    ../common/nixpkgs.nix
    inputs.self.nixosModules.default
    inputs.self.nixosModules.persistence
    inputs.self.nixosModules.swap
  ];

  time.timeZone = "CET";
}
