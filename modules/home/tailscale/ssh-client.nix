{ lib, inputs, ... }:
let
  tailscaleDevices = lib.pipe inputs.self.homeConfigurations [
    lib.attrsToList
    (builtins.filter (cfg: builtins.elem "--ssh" cfg.value.config.self.tailscale.upFlags))
    (map (cfg: cfg.name))
  ];
in
{
  self.ssh-client.config = lib.concatMapStrings (device: ''
    Host ${device}
  '') tailscaleDevices;
}
