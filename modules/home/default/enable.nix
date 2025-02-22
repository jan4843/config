{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    envs
    scripts
    sideband
  ];
}
