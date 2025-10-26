{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.maestral ];
    };

  home-manager = {
    self.open-at-login.maestral = {
      appPath = "/Applications/Maestral.app";
    };
  };
}
