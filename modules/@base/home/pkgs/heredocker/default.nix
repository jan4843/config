{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "heredocker";
  src = ./.;
  nativeBuildInputs = [ pkgs.installShellFiles ];
  installPhase = ''
    install -D heredocker $out/bin/@
    installShellCompletion --name=@ completions.bash
  '';
}
