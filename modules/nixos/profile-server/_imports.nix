{ inputs, ... }:
{
  homeConfig.imports = with inputs.self.homeModules; [
    profile-any-extra
  ];
}
