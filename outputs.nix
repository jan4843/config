{ self, ... }@inputs:
let
  mapDir = import ./lib/mapDir.nix { };
in
{
  lib = mapDir (path: import path inputs) ./lib;

  darwinConfigurations = mapDir self.lib.mkDarwin ./config/darwin;
  nixosConfigurations = mapDir self.lib.mkNixOS ./config/nixos;
  homeConfigurations = mapDir self.lib.mkHome ./config/home;

  darwinModules = self.lib.mkModules ./modules/darwin;
  nixosModules = self.lib.mkModules ./modules/nixos;
  homeModules = self.lib.mkModules ./modules/home;

  overlays.default = final: prev: {
    self = self.lib.mapDir (path: final.callPackage path { }) ./packages;
  };
}
