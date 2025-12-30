inputs:
let
  filterInputs = import ./filterInputs.nix;
  mkLib = import ./mkLib.nix;
  mkNixpkgs = import ./mkNixpkgs.nix;
  mapDir = import ./mapDir.nix;

  inputs' = filterInputs "linux" inputs;
in
mapDir (inputs.self + "/hosts/nixos") (
  name: path:
  (mkLib inputs').nixosSystem {
    specialArgs = {
      inputs = inputs';
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
