{ inputs, pkgs, ... }:
{
  home.stateVersion = "24.11";

  imports = with inputs.self.homeModules; [
    default

    bash
    chiaki
    git
    gnu-utils
    heroic
    ips
    nix
    opengoal
    ping
    retrodeck
    steamos
    tailscale-linux
    tree
    vim
    wget
    yuzu
  ];

  home.packages = with pkgs; [
    magic-wormhole
    mame-tools
    unar
  ];

  programs.librewolf.enable = true;
}
