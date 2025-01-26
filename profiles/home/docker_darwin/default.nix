{ inputs, ... }:
{
  imports = [ inputs.self.homeProfiles.docker ];

  self.homebrew.casks = [ "homebrew/cask/docker" ];

  self.open-at-login.docker.appPath = "/Applications/Docker.app";
}
