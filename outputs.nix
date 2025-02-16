{ self, ... }@inputs:
{
  lib = (import ./lib/mapDir.nix { }) (path: import path inputs) ./lib;

  darwinConfigurations = self.lib.mkConfigs "darwin" ./config;
  nixosConfigurations = self.lib.mkConfigs "nixos" ./config;
  homeConfigurations = self.lib.mkConfigs "system" ./config;

  darwinModules = self.lib.mkModules ./modules/darwin;
  nixosModules = self.lib.mkModules ./modules/nixos;
  homeModules = self.lib.mkModules ./modules/home;

  packages = {
    aarch64-darwin.darwin-rebuild = inputs.nix-darwin.packages.aarch64-darwin.darwin-rebuild;
    x86_64-darwin.darwin-rebuild = inputs.nix-darwin.packages.x86_64-darwin.darwin-rebuild;

    aarch64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.aarch64-linux.nixos-rebuild;
    x86_64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.x86_64-linux.nixos-rebuild;

    aarch64-linux.home-manager = inputs.home-manager_linux.packages.aarch64-linux.home-manager;
    x86_64-linux.home-manager = inputs.home-manager_linux.packages.x86_64-linux.home-manager;
  };

  overlays.default = final: prev: {
    self = self.lib.mapDir (path: final.callPackage path { }) ./packages;
  };
}
