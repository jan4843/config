inputs:
let
  inputs' = inputs.self.lib.filterInputs "darwin" inputs;
in
inputs'.nix-darwin.lib.darwinSystem {
  specialArgs.inputs = inputs';
  modules = inputs.self.lib.siblingsOf ./default.nix;
}
