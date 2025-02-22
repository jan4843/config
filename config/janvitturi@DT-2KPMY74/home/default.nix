{ inputs, pkgs, ... }:
{
  home.stateVersion = "24.11";

  imports = with inputs.self.homeModules; [
    default

    bash
    git
    gnu-utils
    ips
    nix
    tree
    vim
    vscode-config
    wget
  ];

  home.packages = with pkgs; [
    htop
    unar
  ];
}
