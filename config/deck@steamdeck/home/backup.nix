{ inputs, ... }:
{
  imports = [ inputs.self.homeModules.backup ];

  self.backup = {
    repositoryFile = builtins.toFile "" "/run/media/mmcblk0p1/backup";
    passwordFile = builtins.toFile "" "local";
    retention = {
      hourly = 24 * 7;
      daily = 365;
      yearly = 999;
    };
  };
}
