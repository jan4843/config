{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "c";
  src = ./.;
  nativeBuildInputs = [ pkgs.installShellFiles ];
  installPhase = ''
    install -D c $out/bin/c
    installShellCompletion --name=c completions.bash
  '';
}
