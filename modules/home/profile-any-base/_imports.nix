{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    home-manager
    open-at-login
    tcc
  ];
}
