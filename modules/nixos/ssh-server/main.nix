{
  config,
  lib,
  pkgs,
  ...
}:
let
  authorizedKeysFile = "${config.self.persistence.path}/ssh/authorized_keys";
in
{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    authorizedKeysFiles = [ authorizedKeysFile ];
    hostKeys = [
      rec {
        type = "ed25519";
        path = "${config.self.persistence.path}/ssh/ssh_host_${type}_key";
      }
    ];
  };

  systemd.services.ssh-import-id = {
    startAt = "*:0/5";
    path = with pkgs; [
      ssh-import-id
      openssh
    ];
    script = ''
      ssh-import-id \
        --output=${lib.escapeShellArg authorizedKeysFile} \
        ${lib.escapeShellArg config.self.ssh-server.importID}
    '';
  };
}
