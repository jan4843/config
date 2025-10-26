{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.alfred ];
    };

  home-manager =
    let
      appPath = "/Applications/Alfred 5.app";
    in
    {
      self.tcc = {
        Accessibility = [ appPath ];
        SystemPolicyAllFiles = [ appPath ];
      };

      self.open-at-login.alfred = {
        inherit appPath;
      };
    };
}
