inputs:
let
  lib' = {
    pipe = builtins.foldl' (x: f: f x);

    flatten =
      xs: builtins.foldl' (acc: x: acc ++ (if builtins.isList x then lib'.flatten x else [ x ])) [ ] xs;

    contains = infix: string: builtins.length (builtins.split infix string) > 1;

    mapDir =
      root: fn:
      lib'.pipe root [
        builtins.readDir
        builtins.attrNames
        (map (file: {
          name = file;
          value = "${root}/${file}";
        }))
        builtins.listToAttrs
        (builtins.mapAttrs (
          name: path:
          let
            containsNixFiles = lib'.pipe path [
              builtins.readDir
              builtins.attrNames
              (builtins.filter (file: lib'.contains ''\.nix$'' file))
              builtins.length
              (x: x > 0)
            ];
          in
          if containsNixFiles then fn name path else lib'.mapDir path fn
        ))
      ];

    findNixFilesRec =
      dir:
      lib'.pipe dir [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (file: !lib'.contains ''^\.'' file))
        (map (
          file:
          if builtins.pathExists "${dir}/${file}/" then
            lib'.findNixFilesRec "${dir}/${file}"
          else
            "${dir}/${file}"
        ))
        lib'.flatten
        (builtins.filter (path: lib'.contains ''\.nix$'' (builtins.baseNameOf path)))
      ];

    genSystems =
      fn:
      lib'.pipe lib'.flakeExposed [
        (map (system: {
          name = system;
          value = fn rec {
            inputs = inputs'.${if lib'.contains "darwin" system then "darwin" else "linux"};
            lib = pkgs.lib;
            pkgs = inputs.nixpkgs.legacyPackages.${system};
          };
        }))
        builtins.listToAttrs
      ];

    flakeExposed = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  inputs' =
    let
      filter =
        platform:
        lib'.pipe inputs [
          builtins.attrNames
          (builtins.filter (name: lib'.contains "_${platform}$" name || !lib'.contains "_" name))
          (map (name: {
            name = builtins.replaceStrings [ "_${platform}" ] [ "" ] name;
            value = inputs.${name};
          }))
          builtins.listToAttrs
        ];
    in
    {
      darwin = filter "darwin";
      linux = filter "linux";
    };

  mkModules =
    path:
    lib'.pipe path [
      builtins.readDir
      builtins.attrNames
      (map (module: {
        name = module;
        value = lib'.pipe /.${path}/${module} [
          builtins.readDir
          builtins.attrNames
          (builtins.filter (lib'.contains ''\.nix$''))
          (map (file: /.${path}/${module}/${file}))
          (imports: { inherit imports; })
        ];
      }))
      builtins.listToAttrs
    ];
in
{
  apps = lib'.genSystems (
    { inputs, pkgs, ... }:
    lib'.mapDir ./apps (
      _: path: {
        type = "app";
        program = pkgs.lib.getExe (pkgs.callPackage path { inherit inputs; });
      }
    )
  );

  packages = lib'.genSystems (
    { inputs, pkgs, ... }: lib'.mapDir ./pkgs (_: path: pkgs.callPackage path { inherit inputs; })
  );

  nixosModules = mkModules ./modules/nixos;
  darwinModules = mkModules ./modules/darwin;
  homeModules = mkModules ./modules/home;

  nixosConfigurations = lib'.mapDir ./hosts/nixos (
    name: path:
    inputs'.linux.nixpkgs.lib.nixosSystem {
      specialArgs.inputs = inputs'.linux;
      modules = lib'.findNixFilesRec path ++ [ { networking.hostName = name; } ];
    }
  );

  darwinConfigurations = lib'.mapDir ./hosts/darwin (
    name: path:
    inputs'.darwin.nix-darwin.lib.darwinSystem {
      specialArgs.inputs = inputs'.darwin;
      modules = lib'.findNixFilesRec path ++ [ { networking.hostName = name; } ];
    }
  );

  homeConfigurations = lib'.mapDir ./hosts/home (
    name: path:
    let
      expr = import path;
      eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
      system = eval.nixpkgs.hostPlatform;
    in
    inputs'.linux.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inputs = inputs'.linux;
        osConfig.networking.hostName = name;
      };
      pkgs = inputs'.linux.nixpkgs.legacyPackages.${system};
      modules = lib'.findNixFilesRec path ++ [
        {
          options.nixpkgs.hostPlatform = inputs'.linux.nixpkgs.lib.mkOption {
            apply = inputs'.linux.nixpkgs.lib.systems.elaborate;
          };
        }
      ];
    }
  );
}
