{ pkgs, ... }@args:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  home.stateVersion = "24.11";

  imports = with args.inputs.self.homeModules; [
    default

    profile-base
    profile-extra

    bash
    docker-podman
    git
    nix
    push
    steam-shortcuts
    tailscale-linux
  ];

  home.packages = with pkgs; [
    librewolf-bin
    protontricks
  ];
}
