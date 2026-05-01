{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    (lib.mkAliasOptionModule [ "homeConfig" ] [ "home-manager" "users" config.username ])
  ];

  options.username = lib.mkOption {
    type = lib.types.str;
  };

  config = {
    _module.args.homeConfig = config.home-manager.users.${config.username};
    home-manager = {
      extraSpecialArgs.inputs = inputs;
      useGlobalPkgs = true;
    };
  };
}
