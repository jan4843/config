{
  config,
  lib,
  pkgs,
  ...
}:
let
  authorizedKeysFile = "/nix/persist/ssh/authorized_keys";
in
{
  services.openssh = {
    enable = true;
    authorizedKeysFiles = [ authorizedKeysFile ];
    hostKeys = [
      rec {
        type = "ed25519";
        path = "/nix/persist/ssh/ssh_host_${type}_key";
      }
    ];
  };

  systemd.services.ssh-import-id = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    startAt = "*:0/5";
    path = with pkgs; [
      ssh-import-id
      openssh
    ];
    script = ''
      ssh-import-id --output=${lib.escapeShellArg authorizedKeysFile} ${lib.escapeShellArg config.self.ssh-server.importID}
    '';
  };
}
