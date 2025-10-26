{ inputs, pkgs, ... }:
{
  imports = with inputs.self.homeModules; [
    profile-desktop-extra
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
