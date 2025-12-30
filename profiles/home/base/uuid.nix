{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "uuid" ''exec ${pkgs.util-linux}/bin/uuidgen "$@"'')
  ];
}
