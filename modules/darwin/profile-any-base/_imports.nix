{ inputs, ... }:
{
  homeConfig.imports = with inputs.self.homeModules; [
    profile-any-base
  ];
  imports = with inputs.self.darwinModules; [
    bash
    homebrew
    home-manager
  ];
}
