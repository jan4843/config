{ config, lib, ... }:
let
  app = "${config.home.homeDirectory}/Library/TCC-Helper.app";
in
{
  options.self.tcc-helper = {
    app = lib.mkOption {
      default = app;
      readOnly = true;
    };
    executable = lib.mkOption {
      default = "${app}/Contents/MacOS/tcc-helper";
      readOnly = true;
    };
    bundleIdentifier = lib.mkOption {
      default = "local.tcc-helper";
      readOnly = true;
    };
    permissions = lib.mkOption {
      type = lib.types.listOf (lib.types.enum (builtins.attrNames config.self.tcc));
      default = [ ];
    };
  };
}
