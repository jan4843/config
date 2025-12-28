{ inputs, ... }:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];
  homeConfig.imports = [ inputs.self.homeModules.home-manager ];
}
