{ inputs, ... }:
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

    Host ${toString hosts}
  '';
}
