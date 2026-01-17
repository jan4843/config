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
  users.allowNoPasswordLogin = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    authorizedKeysFiles = [ authorizedKeysFile ];
    hostKeys = lib.singleton rec {
      type = "ed25519";
      path = "${config.self.persistence.path}/ssh/ssh_host_${type}_key";
    };
  };

  systemd.services.ssh-import-id = {
    startAt = "*:0/5";
    path = with pkgs; [
      coreutils
      openssh
      ssh-import-id
    ];
    script = ''
      ssh-import-id \
        --output=${lib.escapeShellArg authorizedKeysFile} \
        ${lib.escapeShellArg config.self.ssh-server.importID}
      chmod a+r ${lib.escapeShellArg authorizedKeysFile}
    '';
  };
}
