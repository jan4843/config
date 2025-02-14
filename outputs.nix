{ self, ... }@inputs:
{
  lib = (import ./lib/mapDir.nix { }) (path: import path inputs) ./lib;

  darwinConfigurations = self.lib.mkConfigs "darwin" ./config;
  nixosConfigurations = self.lib.mkConfigs "nixos" ./config;
  homeConfigurations = self.lib.mkConfigs "system" ./config;

  darwinModules = self.lib.mkModules ./modules/darwin;
  nixosModules = self.lib.mkModules ./modules/nixos;
  homeModules = self.lib.mkModules ./modules/home;

  overlays.default = final: prev: {
    self = self.lib.mapDir (path: final.callPackage path { }) ./packages;
  };
}
