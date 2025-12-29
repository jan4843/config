{ homeConfig, ... }:
{
  nix.settings.trusted-users = [ homeConfig.home.username ];
}
