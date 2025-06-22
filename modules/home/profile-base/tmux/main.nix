{ pkgs, ... }:
{
  home.packages = [ pkgs.tmux ];
  home.file.".tmux.conf".source = ./_tmux.conf;
}
