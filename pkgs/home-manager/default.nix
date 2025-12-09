{ inputs, pkgs, ... }: inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
