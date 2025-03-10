{ pkgs, ... }:
{
  homeConfig.self.bash.functions.pdfdecrypt = ''
    (
      [ $# -gt 0 ] || {
        echo "usage: pdfdecrypt FILE..."
        return 64
      }

      read -rsp "password: "
      echo
      for f in "$@"; do
        ${pkgs.qpdf}/bin/qpdf --decrypt --replace-input --password="$REPLY" "$f"
        rm -f "$f.~qpdf-orig"
      done
    )
  '';
}
