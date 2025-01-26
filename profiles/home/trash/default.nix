{ pkgs, ... }:
{
  home.packages = [ pkgs.darwin.trash ];
  home.shellAliases.del = "trash -v";
}
