{
  self.homebrew.casks = [ "iina" ];

  targets.darwin.defaults."com.colliderli.iina" = {
    verticalScrollAction = 2;
    horizontalScrollAction = 2;
  };
}
