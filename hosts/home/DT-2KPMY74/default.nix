{ inputs, pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";

  home.username = "janvitturi";
  home.homeDirectory = "/home/janvitturi";
  home.stateVersion = "24.11";

  imports = with inputs.self.homeModules; [
    default

    asdf
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
