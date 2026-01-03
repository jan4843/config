{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/desktop+")
    inputs.self.homeModules.steam-autogrid
    inputs.self.homeModules.steam-shortcuts
    inputs.self.homeModules.tailscale-userspace
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    librewolf
    protontricks
    hello-unfree
  ];
}
