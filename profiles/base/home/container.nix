{ lib, pkgs, ... }:
let
  pkgs'.container = pkgs.symlinkJoin {
    inherit (pkgs.container)
      name
      pname
      version
      meta
      ;
    paths = [ pkgs.container ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm $out/bin/container
      makeWrapper ${pkgs.container}/bin/container $out/bin/container \
        --run '${pkgs.container}/bin/container system start --enable-kernel-install | ${pkgs.coreutils}/bin/tail -n+2'
    '';
  };
in
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.packages = [
    pkgs'.container
    (pkgs.writeShellScriptBin "docker" ''exec container "$@"'')
  ];
}
