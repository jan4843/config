{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = with inputs.self.homeModules; [
    backup
    bash-config
    chiaki
    git-config
    gnu-utils
    heroic
    nix
    retrodeck
    steamos
    tailscale-linux
    tree
    vim
    wget
    yuzu
  ];

  self.backup = {
    repositoryFile = pkgs.writeText "" "/run/media/mmcblk0p1/backup";
    passwordFile = pkgs.writeText "" "local";
    retention = {
      hourly = 24 * 7;
      daily = 365;
      yearly = 999;
    };
  };

  self.tailscale = {
    tags = [ "edge" ];
    upFlags = [ "--ssh" ];
  };
}
