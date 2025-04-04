{ lib, pkgs, ... }:
{
  modules,
  modulesHash ? "",
}:
let
  caddyModulePrefix = "github.com/caddyserver/caddy/v2@";
  buildArgs = lib.pipe modules [
    lib.naturalSort
    (map (x: "--with=${x}"))
    lib.escapeShellArgs
  ];
in
pkgs.caddy.overrideAttrs (
  final: prev: {
    version = lib.pipe modules [
      (builtins.filter (lib.hasPrefix caddyModulePrefix))
      builtins.head
      (lib.removePrefix caddyModulePrefix)
    ];
    vendorHash = null;
    subPackages = [ "." ];
    src =
      pkgs.runCommand "caddy-src"
        {
          outputHash = modulesHash;
          outputHashAlgo = lib.optional (modulesHash == "") "sha256";
          outputHashMode = "recursive";
          nativeBuildInputs = [ pkgs.go ];
        }
        ''
          export GOCACHE=$TMPDIR/go-cache GOPATH=$TMPDIR/go
          XCADDY_SKIP_BUILD=1 TMPDIR=$PWD ${pkgs.xcaddy}/bin/xcaddy build ${buildArgs}
          mv buildenv* $out; cd $out
          go mod vendor
          go mod edit -go=1.0
        '';
  }
)
