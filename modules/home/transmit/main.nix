args: {
  self.homebrew.casks = with args.config.self.homebrew.taps."homebrew/cask".casks; [
    transmit
  ];

  targets.darwin.defaults."com.panic.transmit" = {
    SplitCollapsedIndex = 0;
    ShowHiddenFiles = true;
  };

  self.backup.paths = [
    "${args.config.home.homeDirectory}/Library/Application Support/Transmit/Connections.transmitstore"
    "${args.config.home.homeDirectory}/Library/Application Support/Transmit/Metadata"
  ];
}
