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
            in
            {
              name = if isNixFile then nixFileName else file;
              value =
                if isNixFile then
                  fn nixFileName root
                else if isRoot then
                  fn file "${root}/${file}"
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
      name: path: {
        imports = map (mkModule type) (lib'.findNixFilesRec path);
      }
    );
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

  nixosModules = mkModules "nixos" ./modules;
  darwinModules = mkModules "nix-darwin" ./modules;
  homeModules = mkModules "home-manager" ./modules;

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
