{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    inputs.home-manager.darwinModules.home-manager
  ];

  homeConfig.imports = [ inputs.self.homeModules.home-manager ];

  home-manager = {
    extraSpecialArgs.inputs = inputs;
    useGlobalPkgs = true;
  };
}
