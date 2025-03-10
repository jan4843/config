{ inputs, pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";

  home.username = "deck";
  home.homeDirectory = "/home/deck";
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
    vulkan
    wget
  ];

  home.packages = with pkgs; [
    librewolf-bin
    magic-wormhole
    mame-tools
    unar
  ];
}
