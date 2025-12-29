{
  config,
  extendModules,
  lib,
  ...
}:
let
  username = original.config.homeConfig.home.username;
  original = extendModules {
    modules = [
      {
        disabledModules = [ { key = "_homeConfigAlias"; } ];
        options.homeConfig = lib.mkOption { };
      }
    ];
  };
in
{
  imports = [
    {
      key = "_homeConfigAlias";
      imports = [ (lib.mkAliasOptionModule [ "homeConfig" ] [ "home-manager" "users" username ]) ];
      config = {
        _module.args.homeConfig = config.home-manager.users.${username};
      };
    }
  ];
}
