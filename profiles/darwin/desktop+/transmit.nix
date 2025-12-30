{ casks, homeConfig, ... }:
{
  self.homebrew.casks = [ casks.transmit ];

  homeConfig = {
    targets.darwin.defaults."com.panic.transmit" = {
      SplitCollapsedIndex = 0;
      ShowHiddenFiles = true;
    };

    self.backup.paths = [
      "${homeConfig.home.homeDirectory}/Library/Application Support/Transmit/Connections.transmitstore"
      "${homeConfig.home.homeDirectory}/Library/Application Support/Transmit/Metadata"
    ];
  };
}
