{ config, ... }:
{
  nix.settings.trusted-users = [ config.homeConfig.home.username ];
}
