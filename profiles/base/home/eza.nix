{ pkgs, ... }:
{
  home.packages = [ pkgs.eza ];

  home.shellAliases.ll = toString [
    "eza"

    "--long"
    "--icons=never"
    "--no-quotes"

    "--almost-all"
    "--group-directories-first"

    "--binary"
    "--group"
    "--mounts"
    "--time-style=long-iso"
    "--git"
  ];
}
