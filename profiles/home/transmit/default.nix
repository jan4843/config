{ config, ... }:
{
  self.homebrew.casks = [ "homebrew/cask/transmit" ];

  targets.darwin.defaults."com.panic.transmit" = {
    SplitCollapsedIndex = 0;
    ShowHiddenFiles = true;
  };

  self.backup.paths = [
    "${config.home.homeDirectory}/Library/Application Support/Transmit/Connections.transmitstore"
    "${config.home.homeDirectory}/Library/Application Support/Transmit/Metadata"
  ];
}
