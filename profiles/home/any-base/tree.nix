{ pkgs, ... }:
{
  home.packages = [ pkgs.tree ];
  home.shellAliases.tree = "tree -aACF";
}
