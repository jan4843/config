{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.iina ];
    };

  home-manager =
    { config, ... }:
    {
      targets.darwin.defaults."com.colliderli.iina" = {
        verticalScrollAction = 2;
        horizontalScrollAction = 2;
      };
    };
}
