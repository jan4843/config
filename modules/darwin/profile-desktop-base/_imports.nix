{ inputs, ... }:
{
  imports = with inputs.self.darwinModules; [
    profile-any-base
    vscode
  ];
  homeConfig.imports = with inputs.self.homeModules; [
    profile-desktop-base
  ];
}
