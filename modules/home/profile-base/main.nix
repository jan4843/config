{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    file
    fswatch
    htop
    jq
    ncdu
    pv
    rsync
    unar
    watch
  ];
}
