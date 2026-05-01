{ config, lib, ... }:
{
  system.primaryUser = lib.mkDefault config.username;
  users.users.${config.username}.home = lib.mkDefault "/Users/${config.username}";
}
