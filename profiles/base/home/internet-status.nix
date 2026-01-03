{ pkgs, ... }:
let
  pkgs'.internet-status = pkgs.writeShellApplication {
    name = "internet-status";
    runtimeInputs = with pkgs; [
      inetutils
      gawk
      jq
      dnsutils
    ];
    text = ''
      is_up() { ping -c1 -w1 "$1" >/dev/null 2>&1; }

      die() { echo "$@"; exit 1; }

      router=$(${
        if pkgs.stdenv.hostPlatform.isDarwin then
          "route -n get default | awk '/gateway:/{print $2}'"
        else
          "ip --json route show default 0.0.0.0/0 | jq --raw-output 'sort_by(.metric)[0].gateway'"
      })

      if [ -z "$router" ]; then
        die "no router available"
      elif ! is_up "$router"; then
        die "router not reachable"
      elif is_up 1.1.1.1 || is_up 8.8.8.8; then
        if dig +time=1 +tries=1 google.com >/dev/null 2>&1; then
          echo "internet is reachable"
        else
          die "DNS not working"
        fi
      else
        die "internet not reachable"
      fi
    '';
  };
in
{
  home.packages = [ pkgs'.internet-status ];
}
