{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = with inputs.self.homeProfiles; [
    bash
    gnu-utils
    nix
    yuzu
  ];

  self.backup = {
    enable = true;
    repositoryFile = pkgs.writeText "" "/run/media/mmcblk0p1/backup";
    passwordFile = pkgs.writeText "" "local";
    paths = [
      "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/*/pfx/drive_c/users/steamuser"
      "${config.home.homeDirectory}/retrodeck/saves"
      "${config.home.homeDirectory}/retrodeck/states"
    ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
      yearly = 999;
    };
  };

  self.tailscale = {
    enable = true;
    tags = [ "edge" ];
    upFlags = [ "--ssh" ];
  };
}
