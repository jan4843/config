{ inputs, pkgs, ... }: inputs.home-manager.packages.${pkgs.hostPlatform.system}.home-manager
