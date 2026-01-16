inputs:
let
  inputs' = inputs.self.lib.filterInputs "linux" inputs;
in
inputs'.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs'.nixpkgs.legacyPackages.x86_64-linux;
  extraSpecialArgs.inputs = inputs';
  modules = inputs.self.lib.siblingsOf ./default.nix;
}
