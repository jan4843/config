{ pkgs, ... }:
{
  home.packages = [ pkgs.vim ];
  home.file.".vimrc".source = ./files/vimrc;
}
