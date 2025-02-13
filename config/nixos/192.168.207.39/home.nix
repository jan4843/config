{ inputs, pkgs, ... }:
{
  imports = with inputs.self.homeModules; [
    bash
    gnu-utils
    nix
    vim
  ];

  home.packages = with pkgs; [
    gnumake
    jq
  ];
}
