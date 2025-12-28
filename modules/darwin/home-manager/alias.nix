{ extendModules, lib, ... }:
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
        system.primaryUser = lib.mkDefault username;
        users.users.${username}.home = lib.mkDefault "/Users/${username}";
      };
    }
  ];
}
