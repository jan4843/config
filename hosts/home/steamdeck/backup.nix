{ config, ... }:
{
  self.backup = {
    repositoryFile = builtins.toFile "repo" "/run/media/mmcblk0p1/backup";
    passwordFile = builtins.toFile "pass" "local";
    paths = [
      "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/*/pfx/drive_c/users"
    ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
      weekly = 0;
      monthly = 0;
      yearly = 999;
    };
  };
}
