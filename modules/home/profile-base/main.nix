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
    rsync
    unar
    watch
  ];
}
