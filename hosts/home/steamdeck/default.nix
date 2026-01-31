{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    inputs.self.homeModules.steam-shortcuts
    inputs.self.homeModules.sudo-passwordless
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  home.stateVersion = "25.11";
  home.username = "deck";
  home.homeDirectory = "/home/deck";

  nixpkgs.config.allowUnfree = true;

  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
    vulkan.enable = true;
  };

  self.sudo-passwordless.path = "/usr/bin/sudo";
}
