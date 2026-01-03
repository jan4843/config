{ casks, ... }:
{
  self.homebrew.casks = [ casks.notunes ];

  homeConfig = {
    self.open-at-login.notunes.appPath = "/Applications/noTunes.app";

    targets.darwin.defaults."digital.twisted.noTunes" = {
      hideIcon = true;
    };
  };
}
