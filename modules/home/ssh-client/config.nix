args:
let
  users =
    { }
    // builtins.mapAttrs (
      host: config: config.config.homeConfig.home.username
    ) args.inputs.self.darwinConfigurations
    // builtins.mapAttrs (
      host: config: config.config.homeConfig.home.username
    ) args.inputs.self.nixosConfigurations
    // builtins.mapAttrs (
      host: config: config.config.home.username
    ) args.inputs.self.homeConfigurations;
in
{
  self.ssh-client.config = ''
    Host *
      User root
      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
      LogLevel error

    ${args.lib.concatMapStringsSep "\n" (x: ''
      Host ${x.name}
        User ${x.value}
    '') (args.lib.attrsToList users)}
  '';
}
