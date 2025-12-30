inputs:
let
  filterInputs = import ./filterInputs.nix;
  mkLib = import ./mkLib.nix;
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
      { networking.hostName = name; }
    ];
  }
)
