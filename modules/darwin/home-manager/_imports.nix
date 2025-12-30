{ inputs, ... }:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];
  homeConfig.imports = [ (inputs.self + "/modules/home/home-manager") ];
}
