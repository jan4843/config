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
    ping
    steamos
    tailscale-linux
    tree
    vim
    wget
  ];

  home.packages = with pkgs; [
    magic-wormhole
    mame-tools
    unar
  ];

  programs.librewolf.enable = true;
}
