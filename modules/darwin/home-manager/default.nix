{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    inputs.home-manager.darwinModules.home-manager
  ];

  homeConfig.imports = [ (inputs.self + "/modules/home/home-manager") ];

  home-manager = {
    extraSpecialArgs.inputs = inputs;
    useGlobalPkgs = true;
  };
}
