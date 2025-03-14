args: {
  self.homebrew.taps = {
    "homebrew/core" = args.inputs.homebrew-core;
    "homebrew/cask" = args.inputs.homebrew-cask;
    "homebrew/bundle" = args.inputs.homebrew-bundle;
  };

  _module.args.casks = args.config.self.homebrew.taps."homebrew/cask".casks;
}
