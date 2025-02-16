{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    envs
    home-manager
    scripts
    sideband
  ];
}
