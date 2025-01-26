{ self, ... }:
{
  system,
  home,
}:
let
  inputs = self.lib.filterInputs "darwin";
in
inputs.nix-darwin.lib.darwinSystem {
  specialArgs = {
    inherit inputs;
  };

  modules = [
    inputs.home-manager.darwinModules.home-manager
    {
      system.stateVersion = system.stateVersion or null;
      nixpkgs.hostPlatform = system.platform;
      users.users.${home.user}.home = home.directory;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
        };

        users.${home.user} = {
          home.stateVersion = home.stateVersion or null;
          imports = home.modules or [ ];
        };
      };
    }
  ] ++ (system.modules or [ ]);
}
