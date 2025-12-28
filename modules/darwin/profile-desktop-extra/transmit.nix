{ casks, config, ... }:
{
  ois.homebrew.casks = [ casks.transmit ];

  homeConfig = {
    targets.darwin.defaults."com.panic.transmit" = {
      SplitCollapsedIndex = 0;
      ShowHiddenFiles = true;
    };

    self.backup.paths = [
      "${config.homeConfig.home.homeDirectory}/Library/Application Support/Transmit/Connections.transmitstore"
      "${config.homeConfig.home.homeDirectory}/Library/Application Support/Transmit/Metadata"
    ];
  };
}
