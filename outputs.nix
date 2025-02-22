inputs:
let
  lib' = {
    pipe = builtins.foldl' (x: f: f x);

    readDir =
      dir:
      lib'.pipe dir [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (lib'.hasSuffix ".nix"))
        (map (name: "${dir}/${name}"))
      ];

    mapDir =
      fn: dir:
      lib'.pipe dir [
        builtins.readDir
        builtins.attrNames
        (map (name: {
          inherit name;
          value = fn "${dir}/${name}";
        }))
        builtins.listToAttrs
      ];

    hasInfix = infix: content: builtins.length (builtins.split infix content) > 1;

    hasSuffix =
      suffix: content:
      let
        lenSuffix = builtins.stringLength suffix;
        lenContent = builtins.stringLength content;
      in
      (
        (lenContent >= lenSuffix)
        && (builtins.substring (lenContent - lenSuffix) lenContent content) == suffix
      );

    removeSuffix =
      suffix: content:
      if lib'.hasSuffix suffix content then
        builtins.substring 0 ((builtins.stringLength content) - (builtins.stringLength suffix)) content
      else
        content;
  };

  inputs' =
    let
      untagged = lib'.pipe inputs [
        builtins.attrNames
        (builtins.filter (name: !lib'.hasInfix "_" name))
        (map (name: {
          inherit name;
          value = inputs.${name};
        }))
        builtins.listToAttrs
      ];

      tagged =
        tag:
        lib'.pipe inputs [
          builtins.attrNames
          (builtins.filter (name: lib'.hasSuffix "_${tag}" name))
          (map (name: {
            name = lib'.removeSuffix "_${tag}" name;
            value = inputs.${name};
          }))
          builtins.listToAttrs
        ];
    in
    {
      darwin = untagged // tagged "darwin";
      linux = untagged // tagged "linux";
    };

  modules = rec {
    modulesRoot = ./modules;
    defaultPrefix = "_default_";

    collectModulesRoots =
      type:
      lib'.pipe "${modulesRoot}/${type}" [
        builtins.readDir
        builtins.attrNames
        (map (module: {
          name = module;
          value = "${modulesRoot}/${type}/${module}";
        }))
        (builtins.filter (attr: builtins.pathExists attr.value))
        builtins.listToAttrs
      ];

    collectModulesDefaults =
      root:
      lib'.pipe root [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (f: f == "default.nix"))
        (map (f: "${root}/${f}"))
      ];

    collectModulesFiles =
      root:
      lib'.pipe root [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (f: lib'.hasSuffix ".nix" f))
        (map (f: "${root}/${f}"))
      ];

    modulesImports =
      type:
      lib'.pipe (collectModulesRoots type) [
        (builtins.mapAttrs (name: path: collectModulesFiles path))
        (builtins.mapAttrs (
          name: files: {
            key = name;
            imports = files ++ [
              {
                disabledModules = [ { key = "${defaultPrefix}${name}"; } ];
              }
            ];
          }
        ))
      ];

    defaultImports =
      type:
      lib'.pipe (collectModulesRoots type) [
        (builtins.mapAttrs (name: path: collectModulesDefaults path))
        (builtins.mapAttrs (
          name: files: {
            key = "${defaultPrefix}${name}";
            imports = files;
          }
        ))
        builtins.attrValues
      ];

    mkModules =
      type:
      let
        modules = modulesImports type;
        originalDefaultImports =
          (builtins.filter (imports: !(imports ? disabledModules)))
            modules.default.imports or [ ];
      in
      modules
      // {
        default = {
          key = "default";
          imports = originalDefaultImports ++ defaultImports type;
        };
      };
  };

  configs = rec {
    username =
      path:
      lib'.pipe path [
        builtins.baseNameOf
        (builtins.split "@")
        builtins.head
      ];

    home = username: if username == "root" then "/root" else "/home/${username}";

    mkDarwin =
      path:
      inputs'.darwin.nix-darwin.lib.darwinSystem {
        specialArgs.inputs = inputs'.darwin;
        modules = (lib'.readDir "${path}/darwin") ++ [
          inputs'.darwin.home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = [ inputs'.darwin.self.overlays.default ];
            users.users.${username path}.home = "/Users/${username path}";
            home-manager = {
              extraSpecialArgs.inputs = inputs'.darwin;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username path}.imports = lib'.readDir "${path}/home";
            };
          }
        ];
      };

    mkNixOS =
      path:
      inputs'.linux.nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs'.linux;
        modules = (lib'.readDir "${path}/nixos") ++ [
          inputs'.linux.home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ inputs'.linux.self.overlays.default ];
            users.users.${username path} = {
              home = home (username path);
              linger = true;
            };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs.inputs = inputs'.linux;
              users.${username path}.imports = lib'.readDir "${path}/home";
            };
          }
        ];
      };

    mkHome =
      path:
      inputs'.linux.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs.inputs = inputs'.linux;
        pkgs = inputs'.linux.nixpkgs.legacyPackages.${(import "${path}/system").nixpkgs.hostPlatform};
        modules = (lib'.readDir "${path}/home") ++ [
          {
            nixpkgs.overlays = [ inputs'.linux.self.overlays.default ];
            home = {
              username = username path;
              homeDirectory = home (username path);
            };
          }
        ];
      };

    mkConfig =
      platform:
      if platform == "darwin" then
        mkDarwin
      else if platform == "nixos" then
        mkNixOS
      else if platform == "home" then
        mkHome
      else
        null;

    mkConfigs =
      platform:
      lib'.pipe ./config [
        (lib'.mapDir null)
        builtins.attrNames
        (builtins.filter (name: builtins.pathExists ./config/${name}/${platform}))
        (map (name: {
          inherit name;
          value = mkConfig platform (builtins.toPath ./config/${name});
        }))
        builtins.listToAttrs
      ];
  };
in
{
  darwinConfigurations = configs.mkConfigs "darwin";
  nixosConfigurations = configs.mkConfigs "nixos";
  homeConfigurations = configs.mkConfigs "home";

  darwinModules = modules.mkModules "darwin";
  nixosModules = modules.mkModules "nixos";
  homeModules = modules.mkModules "home";

  packages = {
    aarch64-darwin.darwin-rebuild = inputs'.darwin.nix-darwin.packages.aarch64-darwin.darwin-rebuild;
    x86_64-darwin.darwin-rebuild = inputs'.darwin.nix-darwin.packages.x86_64-darwin.darwin-rebuild;

    aarch64-linux.nixos-rebuild = inputs'.linux.nixpkgs.legacyPackages.aarch64-linux.nixos-rebuild;
    x86_64-linux.nixos-rebuild = inputs'.linux.nixpkgs.legacyPackages.x86_64-linux.nixos-rebuild;

    aarch64-linux.home-manager = inputs'.linux.home-manager.packages.aarch64-linux.home-manager;
    x86_64-linux.home-manager = inputs'.linux.home-manager.packages.x86_64-linux.home-manager;
  };

  overlays.default = final: prev: {
    self = lib'.mapDir (path: final.callPackage path { }) ./pkgs;
  };
}
