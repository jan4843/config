inputs:
let
  mapDir = import ./mapDir.nix;
in
inputs.nixpkgs.lib.extend (
  final: prev: {
    self = mapDir (inputs.self + "/lib") (
      name: path:
      import path {
        inherit inputs;
        lib = final;
      }
    );
  }
)
