{ lib, ... }:
{
  self.grafana = {
    remoteWriteURLFile = lib.mkDefault "/nix/secrets/personal/grafana.remote-write-url";
  };
}
