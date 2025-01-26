{ self, ... }:
{
  system,
  home,
}:
let
  inputs = self.lib.filterInputs "linux";
in
inputs.home-manager.lib.homeManagerConfiguration {
  extraSpecialArgs = {
    inherit inputs;
  };

  pkgs = inputs.nixpkgs.legacyPackages.${system.platform};

  modules = [
    {
      home = {
        username = home.user;
        homeDirectory = home.directory;
        stateVersion = home.stateVersion or null;
      };
    }
  ] ++ (home.modules or [ ]);
}
