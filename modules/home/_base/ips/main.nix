{ pkgs, ... }:
let
  ips = pkgs.writeShellApplication {
    name = "ips";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      gawk
      gnused
      jq
    ];
    text = builtins.readFile ./.src/ips.bash;
  };
in
{
  home.packages = [ ips ];
}
