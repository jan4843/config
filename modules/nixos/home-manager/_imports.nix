{ inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  homeConfig.imports = [ (inputs.self + "/modules/home/home-manager") ];
}
