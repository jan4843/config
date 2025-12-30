inputs: system:
let
  mkLib = import ./mkLib.nix;
in
import inputs.nixpkgs {
  inherit system;
  config.allowUnfree = true;
  overlays = [
    (final: prev: {
      self = inputs.self.packages.${system};
      lib = mkLib inputs;
    })
  ];
}
