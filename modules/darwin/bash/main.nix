{ pkgs, ... }:
let
  pkg = pkgs.bashInteractive;
in
{
  environment = {
    shells = [ "/run/current-system/sw${pkg.shellPath}" ];
    systemPackages = [ pkg ];
  };
}
