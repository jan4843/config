{ inputs, pkgs, ... }:
{
  imports = with inputs.self.homeModules; [
    backup
    bash
    chiaki
    git
    gnu-utils
    heroic
    ips
    nix
    opengoal
    retrodeck
    steamos
    tailscale-linux
    tree
    vim
    wget
    yuzu
  ];

  home.packages = with pkgs; [
    magic-wormhole
    mame-tools
    unar
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
