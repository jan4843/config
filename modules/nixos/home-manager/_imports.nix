{ inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  homeConfig.imports = [ inputs.self.homeModules.home-manager ];
}
