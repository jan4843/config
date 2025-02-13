{ self, ... }:
{
  system,
  home,
}:
let
  inputs = self.lib.filterInputs "linux";
in
inputs.nixpkgs.lib.nixosSystem {
  specialArgs.inputs = inputs;

  modules = [
    inputs.home-manager.nixosModules.home-manager
    {
      system.stateVersion = system.stateVersion or null;

      users.users.${home.user} = {
        home = home.directory;
        linger = true;
      };

      nixpkgs = {
        config.allowUnfree = true;
        hostPlatform = system.platform;
        overlays = [ inputs.self.overlays.default ];
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs.inputs = inputs;

        users.${home.user} = {
          home.stateVersion = home.stateVersion or null;
          imports = home.modules or [ ];
        };
      };
    }
  ] ++ (system.modules or [ ]);
}
