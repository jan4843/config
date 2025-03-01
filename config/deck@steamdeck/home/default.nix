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
    push
    steamos
    tailscale-linux
    tree
    vim
    vkbasalt
    wget
  ];

  home.packages = with pkgs; [
    magic-wormhole
    mame-tools
    unar
  ];

  programs.librewolf.enable = true;
}
