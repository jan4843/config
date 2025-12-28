{ config, lib, ... }:
{
  programs.bash = {
    enable = true;
    initExtra = lib.mkAfter config.self.bash.profile;
  };
}
