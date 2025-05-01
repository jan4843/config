{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    file
    fswatch
    htop
    jq
    lazygit
    lazydocker
    ncdu
    pv
    rclone
    rsync
    unar
    watch
  ];
}
