{ self, ... }:
type: dir:
let
  attrsToList =
    attrs:
    builtins.map (name: {
      inherit name;
      value = attrs.${name};
    }) (builtins.attrNames attrs);

  readDir = path: builtins.attrValues (self.lib.mapDir (x: x) path);

  configs = builtins.listToAttrs (
    builtins.filter (x: x.value != null) (
      attrsToList (
        self.lib.mapDir (path: if builtins.pathExists "${path}/${type}" then path else null) dir
      )
    )
  );

  inputs = {
    darwin = self.lib.filterInputs "darwin";
    linux = self.lib.filterInputs "linux";
  };

  mkNixOS =
    { path, username }:
    inputs.linux.nixpkgs.lib.nixosSystem {
      specialArgs.inputs = inputs.linux;

      modules = (readDir "${path}/nixos") ++ [
        inputs.linux.home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [ inputs.linux.self.overlays.default ];

          users.users.${username} = {
            home = if username == "root" then "/root" else "/home/${username}";
            linger = true;
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs.inputs = inputs.linux;
            users.${username}.imports = readDir "${path}/home";
          };
        }
      ];
    };

  mkDarwin =
    { path, username }:
    inputs.darwin.nix-darwin.lib.darwinSystem {
      specialArgs.inputs = inputs.darwin;

      modules = (readDir "${path}/darwin") ++ [
        inputs.darwin.home-manager.darwinModules.home-manager
        {
          nixpkgs.overlays = [ inputs.darwin.self.overlays.default ];

          users.users.${username}.home = "/Users/${username}";

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs.inputs = inputs.darwin;
            users.${username}.imports = readDir "${path}/home";
          };
        }
      ];
    };

  mkHome =
    { path, username }:
    inputs.linux.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs.inputs = inputs.linux;

      pkgs = inputs.linux.nixpkgs.legacyPackages.${(import "${path}/system").nixpkgs.hostPlatform};

      modules = (readDir "${path}/home") ++ [
        {
          nixpkgs.overlays = [ inputs.linux.self.overlays.default ];

          home = {
            inherit username;
            homeDirectory = if username == "root" then "/root" else "/home/${username}";
          };
        }
      ];
    };
in
builtins.mapAttrs (
  name: path:
  (
    if type == "nixos" then
      mkNixOS
    else if type == "darwin" then
      mkDarwin
    else if type == "system" then
      mkHome
    else
      abort "invalid config type '${type}'"
  )
    {
      inherit path;
      username = builtins.head (builtins.split "@" (builtins.baseNameOf path));
    }
) configs
