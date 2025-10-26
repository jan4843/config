{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.docker-desktop ];
    };

  home-manager = {
    self.open-at-login.docker.appPath = "/Applications/Docker.app";
  };
}
