{ pkgs, ... }:
{
  home.packages = [ pkgs.wget ];
  home.file.".wgetrc".source = ./_files/wgetrc;
}
