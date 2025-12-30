{ ... }:
inputs: name: path:
let
  inputs' = inputs.self.lib.filterInputs "darwin" inputs;
in
inputs'.nix-darwin.lib.darwinSystem {
  specialArgs = {
    inputs = inputs';
    lib = inputs.self.lib.extending inputs';
  };

  modules = [
    path
    { networking.hostName = name; }
  ];
}
