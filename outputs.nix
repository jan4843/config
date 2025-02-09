{ self, ... }@inputs:
let
  mapDir = import ./lib/mapDir.nix { };
  mapImportDir = fn: dir: self.lib.mapDir (path: fn (import path inputs)) dir;
in
{
  lib = mapDir (path: import path inputs) ./lib;

  darwinConfigurations = mapImportDir self.lib.mkDarwin ./config/darwin;
  homeConfigurations = mapImportDir self.lib.mkHome ./config/home;

  darwinModules = self.lib.mkModules ./modules/darwin;
  homeModules = self.lib.mkModules ./modules/home;

  overlays.default = final: prev: self.lib.mapDir (path: final.callPackage path { }) ./packages;
}
