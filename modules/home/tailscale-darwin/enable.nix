{ inputs, ... }:
{
  imports = [ inputs.self.homeModules.tailscale ];

  self.homebrew.casks = [ "homebrew/cask/tailscale" ];

  self.open-at-login.tailscale.appPath = "/Applications/Tailscale.app";
}
