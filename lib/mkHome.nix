{ self, ... }:
path:
let
  inputs = self.lib.filterInputs "linux";
  username = builtins.head (builtins.split "@" (builtins.baseNameOf path));
  readDir = path: builtins.attrValues (self.lib.mapDir (x: x) path);
in
inputs.home-manager.lib.homeManagerConfiguration {
  extraSpecialArgs.inputs = inputs;

  pkgs = inputs.nixpkgs.legacyPackages.${(import "${path}/system").nixpkgs.hostPlatform};

  modules = (readDir "${path}/home") ++ [
    {
      nixpkgs.overlays = [ inputs.self.overlays.default ];

      home = {
        inherit username;
        homeDirectory = if username == "root" then "/root" else "/home/${username}";
      };
    }
  ];
}
