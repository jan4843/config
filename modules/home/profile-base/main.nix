{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    file
    fswatch
    htop
    jq
    lazydocker
    lazygit
    ncdu
    pv
    rclone
    rsync
    unar
    watch
  ];
}
