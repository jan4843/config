{ casks, ... }:
{
  ois.homebrew.casks = [ casks.docker-desktop ];

  homeConfig = {
    self.open-at-login.docker.appPath = "/Applications/Docker.app";
  };
}
