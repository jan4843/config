{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager.users.${config.username}.home.stateVersion = lib.mkDefault config.system.stateVersion;
}
