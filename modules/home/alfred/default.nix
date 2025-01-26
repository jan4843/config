{ lib, ... }:
{
  imports = [
    ./app.nix
    ./hotkey.nix
    ./preferences.nix
    ./sync.nix
  ];

  options.self.alfred = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    syncFolder = lib.mkOption {
      type = lib.types.path;
    };

    preferences = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
  };
}
