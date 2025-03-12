{ extendModules, ... }@args:
let
  username =
    (extendModules {
      modules = [
        {
          disabledModules = [ { key = "_homeConfigAlias"; } ];
          options.homeConfig = args.lib.mkOption { };
        }
      ];
    }).config.homeConfig.home.username;
in
{
  imports = [
    {
      key = "_homeConfigAlias";
      imports = [
        (args.lib.mkAliasOptionModule [ "homeConfig" ] [ "home-manager" "users" username ])
      ];
    }
  ];

  home-manager = {
    extraSpecialArgs.inputs = args.inputs;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
