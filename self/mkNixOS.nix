inputs:
let
  filterInputs = import ./filterInputs.nix;
  mkLib = import ./mkLib.nix;
  mapDir = import ./mapDir.nix;

  inputs' = filterInputs "linux" inputs;
  lib' = mkLib inputs';
in
mapDir (inputs.self + "/hosts/nixos") (
  name: path:
  lib'.nixosSystem {
    specialArgs = {
      inputs = inputs';
      lib = lib';
    };

    modules = [
      path
      (
        { config, lib, ... }:
        {
          networking.hostName = lib.mkDefault name;

          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            (final: prev: {
              self = inputs.self.packages.${config.nixpkgs.hostPlatform.system};
              lib = lib';
            })
          ];
        }
      )
    ];
  }
)
