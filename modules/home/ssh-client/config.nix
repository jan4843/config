{ inputs, lib, ... }:
let
  hosts =
    with inputs.self;
    builtins.attrNames (darwinConfigurations // nixosConfigurations // homeConfigurations);
in
{
  self.ssh-client.config = ''
    Host *
      User root
      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
      LogLevel error

    ${lib.concatMapStringsSep "\n" (
      host:
      let
        parts = builtins.split "@" host;
      in
      ''
        Host ${lib.last parts}
          User ${builtins.head parts}
      ''
    ) hosts}
  '';
}
