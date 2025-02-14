{ self, ... }:
path:
let
  inputs = self.lib.filterInputs "darwin";
  username = builtins.head (builtins.split "@" (builtins.baseNameOf path));
  readDir = path: builtins.attrValues (self.lib.mapDir (x: x) path);
in
inputs.nix-darwin.lib.darwinSystem {
  specialArgs.inputs = inputs;

  modules = (readDir "${path}/system") ++ [
    inputs.home-manager.darwinModules.home-manager
    {
      nixpkgs.overlays = [ inputs.self.overlays.default ];

      users.users.${username}.home = "/Users/${username}";

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs.inputs = inputs;
        users.${username}.imports = readDir "${path}/home";
      };
    }
  ];
}
