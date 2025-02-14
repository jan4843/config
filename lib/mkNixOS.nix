{ self, ... }:
path:
let
  inputs = self.lib.filterInputs "linux";
  username = builtins.head (builtins.split "@" (builtins.baseNameOf path));
  readDir = path: builtins.attrValues (self.lib.mapDir (x: x) path);
in
inputs.nixpkgs.lib.nixosSystem {
  specialArgs.inputs = inputs;

  modules = (readDir "${path}/system") ++ [
    inputs.home-manager.nixosModules.home-manager
    {
      nixpkgs.overlays = [ inputs.self.overlays.default ];

      users.users.${username} = {
        home = if username == "root" then "/root" else "/home/${username}";
        linger = true;
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs.inputs = inputs;
        users.${username}.imports = readDir "${path}/home";
      };
    }
  ];
}
