{ config, inputs, ... }:
{
  imports = [ inputs.self.homeModules.tailscale ];

  self.homebrew.casks = with config.self.homebrew.taps."homebrew/cask".casks; [
    tailscale
  ];

  self.open-at-login.tailscale.appPath = "/Applications/Tailscale.app";
}
