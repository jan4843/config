{ inputs, ... }:
{
  imports = with inputs.self.darwinModules; [
    profile-desktop-base
  ];
  homeConfig.imports = with inputs.self.homeModules; [
    profile-any-extra
  ];
}
