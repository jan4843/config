{ pkgs, ... }@args:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  home.stateVersion = "24.11";

  imports = with args.inputs.self.homeModules; [
    default

    bash
    docker-podman
    git
    gnu-utils
    ips
    nix
    push
    steam-shortcuts
    tailscale-linux
    tree
    vim
    wget
  ];

  home.packages = with pkgs; [
    librewolf-bin
    magic-wormhole
    mame-tools
    protontricks
    unar
  ];
}
