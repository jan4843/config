{ inputs, pkgs, ... }:
{
  imports = with inputs.self.homeModules; [
    profiles.desktop.extra
    steam-autogrid
    steam-shortcuts
    tailscale-userspace
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    librewolf
    protontricks
  ];
}
