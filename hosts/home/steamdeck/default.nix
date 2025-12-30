{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/home/desktop-base")
    (inputs.self + "/modules/home/steam-autogrid")
    (inputs.self + "/modules/home/steam-shortcuts")
    (inputs.self + "/modules/home/tailscale-userspace")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    librewolf
    protontricks
  ];
}
