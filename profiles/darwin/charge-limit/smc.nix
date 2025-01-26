{ lib, pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "smc";
  version = "unstable-${commit}";
  commit = "e1bd672bcd2d72eddff9b6da7b9cae38e35c4206";

  src = (builtins.fetchTree "github:hholtmann/smcFanControl/${commit}") + /smc-command;

  buildInputs = [ pkgs.darwin.IOKit ];

  hardeningDisable = [ "format" ];

  patchPhase = "sed -i '/^CC = gcc/d' Makefile";
  installPhase = "install -D smc $out/bin/smc";

  meta = {
    mainProgram = "smc";
    platforms = lib.platforms.darwin;
  };
}
