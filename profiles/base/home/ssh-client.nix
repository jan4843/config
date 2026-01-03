{ inputs, lib, ... }:
let
  users =
    { }
    // builtins.mapAttrs (host: config: config.config.homeConfig.home.username) (
      inputs.self.darwinConfigurations or { }
    )
    // builtins.mapAttrs (host: config: config.config.homeConfig.home.username) (
      inputs.self.nixosConfigurations or { }
    )
    // builtins.mapAttrs (host: config: config.config.home.username) (
      inputs.self.homeConfigurations or { }
    );
in
{
  imports = [ inputs.self.homeModules.ssh-client ];

  self.ssh-client.config = ''
    Host *
      User root
      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
      LogLevel error

    ${lib.concatMapAttrsStringSep "\n" (host: user: ''
      Host ${host}
        User ${user}
    '') users}
  '';
}
