{ config, ... }:
{
  self.homebrew.casks = with config.self.homebrew.taps."homebrew/cask".casks; [
    transmit
  ];

  targets.darwin.defaults."com.panic.transmit" = {
    SplitCollapsedIndex = 0;
    ShowHiddenFiles = true;
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/Library/Application Support/Transmit/Connections.transmitstore"
    "${config.home.homeDirectory}/Library/Application Support/Transmit/Metadata"
  ];
}
