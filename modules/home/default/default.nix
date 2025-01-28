{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    bash
    envs
    home-manager
    scripts
    sideband
    ssh
  ];
}
