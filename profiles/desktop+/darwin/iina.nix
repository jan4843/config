{ casks, ... }:
{
  self.homebrew.casks = [ casks.iina ];

  homeConfig.targets.darwin.defaults."com.colliderli.iina" = {
    verticalScrollAction = 2;
    horizontalScrollAction = 2;
  };
}
