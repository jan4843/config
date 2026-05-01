{ config, lib, ... }:
{
  home-manager.users.${config.username}.home.stateVersion = lib.mkDefault config.system.stateVersion;
}
