{ pkgs, ... }:
{
  home.packages = [ pkgs.wget ];
  home.file.".wgetrc".source = ./files/wgetrc;
}
