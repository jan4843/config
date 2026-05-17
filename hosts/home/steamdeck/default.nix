{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    _base-extra
    _personal
    steam-autogrid
    steam-shortcuts
    sudo-passwordless
    tailscale-userspace
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
