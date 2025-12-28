{ config, ... }:
{
  users.users.root.linger = true;

  homeConfig = {
    home.stateVersion = config.system.stateVersion;
  };
}
