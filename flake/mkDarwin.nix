inputs:
let
  filterInputs = import ./filterInputs.nix;
  mkLib = import ./mkLib.nix;
  mkNixpkgs = import ./mkNixpkgs.nix;
  mapDir = import ./mapDir.nix;

  inputs' = filterInputs "darwin" inputs;
in
mapDir (inputs.self + "/hosts/darwin") (
  name: path:
  inputs'.nix-darwin.lib.darwinSystem {
    specialArgs = {
      inputs = inputs';
      lib = mkLib inputs';
    };

    modules = [
      path
      (
        { config, lib, ... }:
        {
          networking.hostName = lib.mkDefault name;
          nixpkgs.pkgs = lib.mkDefault (mkNixpkgs inputs' config.nixpkgs.hostPlatform.system);
        }
      )
    ];
  }
)
