{ inputs, pkgs, ... }:
{
  home.stateVersion = "24.11";

  imports = with inputs.self.homeModules; [
    default

    bash
    docker-podman
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
    ncdu
    unar
  ];
}
