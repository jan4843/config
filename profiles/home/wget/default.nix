{ pkgs, ... }:
{
  home.packages = [ pkgs.wget ];
  home.file.".wgetrc".source = ./wgetrc;
}
