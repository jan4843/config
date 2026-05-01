{ pkgs, ... }:
let
  pkgs'.pdfdecrypt = pkgs.writeShellScriptBin "pdfdecrypt" ''
    if [ $# -lt 1 ]; then
      echo "usage: pdfdecrypt FILE..."
      exit 64
    fi

    read -rsp "password: "
    echo
    for f in "$@"; do
      ${pkgs.qpdf}/bin/qpdf --decrypt --replace-input --password="$REPLY" "$f"
      rm -f "$f.~qpdf-orig"
    done
  '';
in
{
  home.packages = [ pkgs'.pdfdecrypt ];
}
