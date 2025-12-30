{ ... }:
inputs: name: path:
let
  contains = infix: string: builtins.length (builtins.split infix string) > 1;
  expr = import path;
  eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
  platform = if contains "darwin" system then "darwin" else "linux";

  system = eval.nixpkgs.hostPlatform;
  inputs' = inputs.self.lib.filterInputs platform inputs;
in
inputs'.home-manager.lib.homeManagerConfiguration {
  extraSpecialArgs = {
    inputs = inputs';
    osConfig.networking.hostName = name;
  };

  lib = inputs.self.lib.extending inputs';
  pkgs = inputs'.nixpkgs.legacyPackages.${system};

  modules = [
    path
    {
      options.nixpkgs.hostPlatform = inputs'.nixpkgs.lib.mkOption {
        apply = inputs'.nixpkgs.lib.systems.elaborate;
      };
    }
  ];
}
