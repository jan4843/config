{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/base+")
    (inputs.self + "/profiles/personal")
    inputs.self.homeModules.steam-shortcuts
    inputs.self.homeModules.sudo-passwordless
    inputs.self.homeModules.tailscale-userspace
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  _module.args.osConfig.networking.hostName = "steamdeck";

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

  programs.bash.initExtra = ''
    __steamos_prompt_command() { :; }
  '';
}
