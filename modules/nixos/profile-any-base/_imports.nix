{ inputs, ... }:
{
  homeConfig.imports = with inputs.self.homeModules; [
    profile-any-base
  ];
  imports = with inputs.self.nixosModules; [
    home-manager
    persistence
    swap
  ];
}
