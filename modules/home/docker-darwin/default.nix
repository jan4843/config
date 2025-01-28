{ inputs, ... }:
{
  imports = [ inputs.self.homeModules.docker ];

  self.homebrew.casks = [ "homebrew/cask/docker" ];

  self.open-at-login.docker.appPath = "/Applications/Docker.app";
}
