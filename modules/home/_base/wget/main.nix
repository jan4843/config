{ pkgs, ... }:
{
  home.packages = [ pkgs.wget ];
  home.file.".wgetrc".source = ./.config/wgetrc;
}
