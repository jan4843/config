args: {
  imports = [ args.inputs.self.homeModules.docker ];

  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    docker-desktop
  ];

  self.open-at-login.docker.appPath = "/Applications/Docker.app";
}
