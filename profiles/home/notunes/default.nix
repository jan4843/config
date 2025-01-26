{
  self.homebrew.casks = [ "homebrew/cask/notunes" ];

  self.open-at-login.notunes.appPath = "/Applications/noTunes.app";

  targets.darwin.defaults."digital.twisted.noTunes" = {
    hideIcon = true;
  };
}
