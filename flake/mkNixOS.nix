inputs:
let
  filterInputs = import ./filterInputs.nix;
  mkLib = import ./mkLib.nix;
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
      { networking.hostName = name; }
    ];
  }
)
