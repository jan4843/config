{
  self.homebrew.casks = [ "homebrew/cask/iina" ];

  targets.darwin.defaults."com.colliderli.iina" = {
    verticalScrollAction = 2;
    horizontalScrollAction = 2;
  };
}
