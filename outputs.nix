inputs:
let
  lib' = {
    pipe = builtins.foldl' (x: f: f x);

    flatten =
      xs: builtins.foldl' (acc: x: acc ++ (if builtins.isList x then lib'.flatten x else [ x ])) [ ] xs;

    contains = infix: string: builtins.length (builtins.split infix string) > 1;

    singleton = xs: if (builtins.length xs) == 1 then builtins.head xs else abort "List not singleton";

    mapDir =
      root: fn:
      if builtins.pathExists root then
        lib'.pipe root [
          builtins.readDir
          builtins.attrNames
          (map (
            file:
            let
              isRoot = builtins.pathExists "${root}/${file}/default.nix";
              isNixFile = lib'.contains ''^[^.].+\.nix$'' "${root}/${file}";
              nixFileName = builtins.substring 0 (builtins.stringLength file - 4) file;
              mapFiles = name: files: fn { inherit name files; };
            in
            {
              name = if isNixFile then nixFileName else file;
              value =
                if isNixFile then
                  mapFiles nixFileName [ "${root}/${file}" ]
                else if isRoot then
                  mapFiles file (lib'.findNixFilesRec "${root}/${file}")
                else
                  lib'.mapDir "${root}/${file}" fn;
            }
          ))
          builtins.listToAttrs
        ]
      else
        { };

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
      lib'.pipe
        [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-linux"
        ]
        [
          (map (system: {
            name = system;
            value = fn rec {
              input = "nixpkgs_${if lib'.contains "darwin" system then "darwin" else "linux"}";
              pkgs = inputs.${input}.legacyPackages.${system};
              lib = pkgs.lib;
            };
          }))
          builtins.listToAttrs
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

  mkModule =
    type: file:
    let
      expr = import file;
    in
    if
      builtins.attrNames (
        {
          nixos = { };
          nix-darwin = { };
          home-manager = { };
        }
        // expr
      ) != [
        "home-manager"
        "nix-darwin"
        "nixos"
      ]
    then
      abort "Invalid attributes (${toString (builtins.attrNames expr)}) in module ${file}"
    else
      {
        _file = file;
        key = file;
        imports = if expr ? ${type} then [ expr.${type} ] else [ ];
      };

  mkModules =
    type: root:
    lib'.mapDir root (
      { files, ... }:
      {
        imports = map (mkModule type) files;
      }
    );
in
{
  apps = lib'.genSystems (
    { lib, pkgs, ... }:
    lib'.mapDir ./apps (
      { files, ... }:
      {
        type = "app";
        program = lib.getExe (pkgs.callPackage (lib'.singleton files) { });
      }
    )
  );

  nixosModules = mkModules "nixos" ./modules;
  darwinModules = mkModules "nix-darwin" ./modules;
  homeModules = mkModules "home-manager" ./modules;

  nixosConfigurations = lib'.mapDir ./hosts/nixos (
    { name, files, ... }:
    inputs'.linux.nixpkgs.lib.nixosSystem {
      specialArgs.inputs = inputs'.linux;
      modules = files ++ [ { networking.hostName = name; } ];
    }
  );

  darwinConfigurations = lib'.mapDir ./hosts/darwin (
    { name, files, ... }:
    inputs'.darwin.nix-darwin.lib.darwinSystem {
      specialArgs.inputs = inputs'.darwin;
      modules = files ++ [ { networking.hostName = name; } ];
    }
  );

  homeConfigurations = lib'.mapDir ./hosts/home (
    { name, files, ... }:
    let
      expr = import (lib'.singleton (builtins.filter (lib'.contains ''/default\.nix$'') files));
      eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
      system = eval.nixpkgs.hostPlatform;
    in
    inputs'.linux.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs.inputs = inputs'.linux;
      pkgs = inputs'.linux.nixpkgs.legacyPackages.${system};
      modules = files ++ [
        {
          options.nixpkgs.hostPlatform = inputs'.linux.nixpkgs.lib.mkOption {
            apply = inputs'.linux.nixpkgs.lib.systems.elaborate;
          };
        }
      ];
    }
  );

  packages = {
    aarch64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.aarch64-linux.nixos-rebuild;
    x86_64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.x86_64-linux.nixos-rebuild;

    aarch64-darwin.darwin-rebuild = inputs.nix-darwin_darwin.packages.aarch64-darwin.darwin-rebuild;

    aarch64-linux.home-manager = inputs.home-manager_linux.packages.aarch64-linux.home-manager;
    x86_64-linux.home-manager = inputs.home-manager_linux.packages.x86_64-linux.home-manager;
  };
}
