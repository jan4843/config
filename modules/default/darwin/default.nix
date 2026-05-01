{ inputs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../system/home.nix
    ../system/nixpkgs.nix
  ];
}
