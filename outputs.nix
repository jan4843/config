inputs:
let
  lib' = {
    pipe = builtins.foldl' (x: f: f x);

    contains = infix: string: builtins.length (builtins.split infix string) > 1;

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
in
{
  lib = rec {
    mapDir = import ./lib/mapDir { };
    filterInputs = import ./lib/filterInputs { };
    mkNixOS = import ./lib/mkNixOS { };
    mkDarwin = import ./lib/mkDarwin { };
    mkHome = import ./lib/mkHome { };
    extending =
      inputs:
      inputs.nixpkgs.lib.extend (
        final: prev: {
          self = mapDir ./lib (
            name: path:
            import path {
              inherit inputs;
              lib = final;
            }
          );
        }
      );
  };

  apps = lib'.genSystems (
    { inputs, pkgs, ... }:
    inputs.self.lib.mapDir ./apps (
      _: path: {
        type = "app";
        program = pkgs.lib.getExe (
          pkgs.callPackage path {
            inherit inputs;
            lib = inputs.self.lib.extending inputs;
          }
        );
      }
    )
  );

  packages = lib'.genSystems (
    { inputs, pkgs, ... }:
    inputs.self.lib.mapDir ./pkgs (
      _: path:
      pkgs.callPackage path {
        inherit inputs;
        lib = inputs.self.lib.extending inputs;
      }
    )
  );

  nixosModules = inputs.self.lib.mapDir ./modules/nixos (name: path: path);
  darwinModules = inputs.self.lib.mapDir ./modules/darwin (name: path: path);
  homeModules = inputs.self.lib.mapDir ./modules/home (name: path: path);

  nixosConfigurations = inputs.self.lib.mapDir ./hosts/nixos (inputs.self.lib.mkNixOS inputs);
  darwinConfigurations = inputs.self.lib.mapDir ./hosts/darwin (inputs.self.lib.mkDarwin inputs);
  homeConfigurations = inputs.self.lib.mapDir ./hosts/home (inputs.self.lib.mkHome inputs);
}
