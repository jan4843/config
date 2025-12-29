{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports =
    lib.self.siblingsOf ./default.nix
    ++ (with inputs.self.homeModules; [
      profile-desktop-base
      steam-autogrid
      steam-shortcuts
      tailscale-userspace
    ]);

  nixpkgs.hostPlatform = "x86_64-linux";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    librewolf
    protontricks
  ];
}
