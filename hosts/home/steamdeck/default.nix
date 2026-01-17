{ inputs, pkgs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/desktop+")
    (inputs.self + "/profiles/personal")
    inputs.self.homeModules.steam-autogrid
    inputs.self.homeModules.steam-shortcuts
    inputs.self.homeModules.tailscale-userspace
  ];

  _module.args.osConfig.networking.hostName = "steamdeck";

  nixpkgs.hostPlatform = "x86_64-linux";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    librewolf
    protontricks
    hello-unfree
  ];
}
