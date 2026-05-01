{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../system/home.nix
    ../system/nixpkgs.nix
  ];
}
