args: {
  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    iina
  ];

  targets.darwin.defaults."com.colliderli.iina" = {
    verticalScrollAction = 2;
    horizontalScrollAction = 2;
  };
}
