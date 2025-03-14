{ config, inputs, ... }:
{
  imports = [ inputs.self.homeModules.docker ];

  self.homebrew.casks = with config.self.homebrew.taps."homebrew/cask".casks; [
    docker
  ];

  self.open-at-login.docker.appPath = "/Applications/Docker.app";
}
