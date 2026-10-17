let
  appPath = "/Applications/Docker.app";
in
{
  self.homebrew.casks = [ "docker-desktop" ];

  self.tcc.SystemPolicyAllFiles = [ appPath ];

  self.open-at-login.docker = {
    inherit appPath;
  };
}
