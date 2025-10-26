{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.notunes ];
    };

  home-manager =
    { config, ... }:
    {
      self.open-at-login.notunes.appPath = "/Applications/noTunes.app";

      targets.darwin.defaults."digital.twisted.noTunes" = {
        hideIcon = true;
      };
    };
}
