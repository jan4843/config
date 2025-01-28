{ lib, inputs, ... }:
let
  tailscaleDevices = lib.pipe inputs.self.homeConfigurations [
    lib.attrsToList
    (builtins.filter (cfg: builtins.elem "--ssh" cfg.value.config.self.tailscale.upFlags))
    (map (cfg: cfg.name))
  ];
in
{
  self.ssh.config = ''
    Host *
      User root

      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
      LogLevel error

    ${lib.concatMapStringsSep "\n" (device: ''
      Host ${device}
    '') tailscaleDevices}
  '';
}
