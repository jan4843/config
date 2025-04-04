{ caddy, pkgs, ... }:
text:
pkgs.runCommand "Caddyfile"
  {
    nativeBuildInputs = [ caddy ];
    unformatted = builtins.toFile "Caddyfile" text;
  }
  ''
    caddy validate --adapter=caddyfile --config=$unformatted
    cat $unformatted | caddy fmt - > $out
  ''
