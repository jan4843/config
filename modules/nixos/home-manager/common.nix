{ extendModules, pkgs, ... }@args:
let
  extended = extendModules {
    modules = [
      {
        disabledModules = [ { key = "_homeConfigAlias"; } ];
        options.homeConfig = args.lib.mkOption { };
      }
    ];
  };
  username = extended.config.homeConfig.home.username;
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

  users.users = args.lib.mkIf pkgs.hostPlatform.isDarwin {
    ${username}.home = args.lib.mkDefault "/Users/${username}";
  };

  homeConfig.home.stateVersion = args.lib.mkIf pkgs.hostPlatform.isLinux args.config.system.stateVersion;
}
