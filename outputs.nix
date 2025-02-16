{ self, ... }@inputs:
let
  pipe = builtins.foldl' (x: f: f x);

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

  modules = rec {
    modulesRoot = ./modules;
    defaultPrefix = "_default_";

    collectModulesRoots =
      type:
      pipe "${modulesRoot}/${type}" [
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
      pipe root [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (f: f == "default.nix"))
        (map (f: "${root}/${f}"))
      ];

    collectModulesFiles =
      root:
      pipe root [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (f: hasSuffix ".nix" f))
        (map (f: "${root}/${f}"))
      ];

    modulesImports =
      type:
      pipe (collectModulesRoots type) [
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
      pipe (collectModulesRoots type) [
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
in
{
  lib = (import ./lib/mapDir.nix { }) (path: import path inputs) ./lib;

  darwinConfigurations = self.lib.mkConfigs "darwin" ./config;
  nixosConfigurations = self.lib.mkConfigs "nixos" ./config;
  homeConfigurations = self.lib.mkConfigs "system" ./config;

  darwinModules = modules.mkModules "darwin";
  nixosModules = modules.mkModules "nixos";
  homeModules = modules.mkModules "home";

  packages = {
    aarch64-darwin.darwin-rebuild = inputs.nix-darwin.packages.aarch64-darwin.darwin-rebuild;
    x86_64-darwin.darwin-rebuild = inputs.nix-darwin.packages.x86_64-darwin.darwin-rebuild;

    aarch64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.aarch64-linux.nixos-rebuild;
    x86_64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.x86_64-linux.nixos-rebuild;

    aarch64-linux.home-manager = inputs.home-manager_linux.packages.aarch64-linux.home-manager;
    x86_64-linux.home-manager = inputs.home-manager_linux.packages.x86_64-linux.home-manager;
  };

  overlays.default = final: prev: {
    self = self.lib.mapDir (path: final.callPackage path { }) ./pkgs;
  };
}
