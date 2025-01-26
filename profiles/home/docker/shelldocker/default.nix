{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "shelldocker";
  src = ./.;
  nativeBuildInputs = [ pkgs.installShellFiles ];
  installPhase = ''
    install -D shelldocker $out/bin/$
    installShellCompletion --name=$ completions.bash
  '';
}
