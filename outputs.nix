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

  mkLib =
    inputs:
    inputs.nixpkgs.lib.extend (
      final: prev: {
        self = lib'.mapDir ./lib (
          name: path:
          import path {
            inherit inputs;
            lib = final;
          }
        );
      }
    );
in
{
  lib = (mkLib inputs'.linux).self;

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

  nixosModules = lib'.mapDir ./modules/nixos (name: path: path);

  darwinModules = lib'.mapDir ./modules/darwin (name: path: path);

  homeModules = lib'.mapDir ./modules/home (name: path: path);

  nixosConfigurations = lib'.mapDir ./hosts/nixos (
    name: path:
    (mkLib inputs'.linux).nixosSystem {
      specialArgs.inputs = inputs'.linux;
      modules = lib'.findNixFilesRec path ++ [ { networking.hostName = name; } ];
    }
  );

  darwinConfigurations = lib'.mapDir ./hosts/darwin (
    name: path:
    inputs'.darwin.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inputs = inputs'.darwin;
        lib = mkLib inputs'.darwin;
      };
      modules = lib'.findNixFilesRec path ++ [ { networking.hostName = name; } ];
    }
  );

  homeConfigurations = lib'.mapDir ./hosts/home (
    name: path:
    let
      expr = import path;
      eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
      system = eval.nixpkgs.hostPlatform;
      inputs'' = inputs'.${if lib'.contains "darwin" system then "darwin" else "linux"};
    in
    inputs''.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inputs = inputs'';
        osConfig.networking.hostName = name;
      };
      lib = mkLib inputs'';
      pkgs = inputs''.nixpkgs.legacyPackages.${system};
      modules = lib'.findNixFilesRec path ++ [
        {
          options.nixpkgs.hostPlatform = inputs''.nixpkgs.lib.mkOption {
            apply = inputs''.nixpkgs.lib.systems.elaborate;
          };
        }
      ];
    }
  );
}
