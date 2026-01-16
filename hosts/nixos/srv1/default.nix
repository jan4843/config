inputs:
let
  inputs' = inputs.self.lib.filterInputs "linux" inputs;
in
inputs'.nixpkgs.lib.nixosSystem {
  specialArgs.inputs = inputs';
  modules = inputs.self.lib.siblingsOf ./default.nix;
}
