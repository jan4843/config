{ config, ... }:
{
  programs.bash = {
    enable = true;
    initExtra = config.self.bash.profile;
  };
}
