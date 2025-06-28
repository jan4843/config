args: {
  imports = [ args.inputs.self.homeModules.tailscale ];

  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    tailscale-app
  ];

  self.open-at-login.tailscale.appPath = "/Applications/Tailscale.app";
}
