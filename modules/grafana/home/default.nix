{ lib, pkgs, ... }:
{
  options.self.grafana = {
    enabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    remoteWriteURLFile = lib.mkOption {
      type = lib.types.path;
    };

    scrapeConfigs = lib.mkOption {
      type = lib.types.attrsOf (pkgs.formats.json { }).type;
      default = { };
    };
  };
}
