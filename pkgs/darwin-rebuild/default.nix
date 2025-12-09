{ inputs, pkgs, ... }: inputs.nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}.darwin-rebuild
