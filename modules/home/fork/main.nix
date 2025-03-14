args: {
  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    fork
  ];

  targets.darwin.defaults."com.DanPristupov.Fork" = {
    defaultSourceFolder = "${args.config.home.homeDirectory}/Developer";
    diffShowHiddenSymbols = true;
  };
}
