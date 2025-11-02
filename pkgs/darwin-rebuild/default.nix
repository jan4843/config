{ inputs, pkgs, ... }: inputs.nix-darwin.packages.${pkgs.hostPlatform.system}.darwin-rebuild
