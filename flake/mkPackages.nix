inputs:
let
  genSystems = import ./genSystems.nix;
  mapDir = import ./mapDir.nix;
  mkLib = import ./mkLib.nix;
in
genSystems inputs (
  { inputs, pkgs, ... }:
  mapDir (inputs.self + "/pkgs") (
    _: path:
    pkgs.callPackage path {
      inherit inputs;
      lib = mkLib inputs;
    }
  )
)
