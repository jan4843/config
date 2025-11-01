inputs:
let
  lib' = {
    pipe = builtins.foldl' (x: f: f x);

    flatten =
      xs: builtins.foldl' (acc: x: acc ++ (if builtins.isList x then lib'.flatten x else [ x ])) [ ] xs;

    contains = infix: string: builtins.length (builtins.split infix string) > 1;

    singleton = xs: if builtins.length xs == 1 then builtins.head xs else abort "List not singleton";

    mapDir =
      fn: dir:
      lib'.pipe dir [
        builtins.readDir
        builtins.attrNames
        (map (name: {
          inherit name;
          value = fn name /.${dir}/${name};
        }))
        builtins.listToAttrs
      ];

    mapDir' =
      root: fn:
      if builtins.pathExists root then
        lib'.pipe root [
          builtins.readDir
          builtins.attrNames
          (map (
            file:
            let
              isRoot = builtins.pathExists "${root}/${file}/default.nix";
              isNixFile = lib'.contains "^[^.].+\.nix$" "${root}/${file}";
              nixFileName = builtins.substring 0 (builtins.stringLength file - 4) file;
              mapFiles = name: files: fn { inherit name files; };
            in
            {
              name = if isNixFile then nixFileName else file;
              value =
                if isNixFile then
                  if builtins.pathExists "${root}/${nixFileName}/" then
                    abort "Mapping conflict between ${root}/${file} and ${root}/${nixFileName}"
                  else
                    mapFiles nixFileName [ "${root}/${file}" ]
                else if isRoot then
                  mapFiles file (lib'.findNixFilesRec "${root}/${file}")
                else
                  lib'.mapDir' "${root}/${file}" fn;
            }
          ))
          (x: builtins.deepSeq x x)
          builtins.listToAttrs
        ]
      else
        { };

    findNixFilesRec =
      dir:
      lib'.pipe dir [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (file: !lib'.contains "^\\." file))
        (map (
          file:
          if builtins.pathExists "${dir}/${file}/" then
            lib'.findNixFilesRec "${dir}/${file}"
          else
            "${dir}/${file}"
        ))
        lib'.flatten
        (builtins.filter (path: lib'.contains "\.nix$" (builtins.baseNameOf path)))
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
    lib'.pipe root [
      builtins.readDir
      builtins.attrNames
      (map (
        dir:
        let
          nixFiles = lib'.pipe "${root}/${dir}" [
            builtins.readDir
            builtins.attrNames
            (builtins.filter (name: lib'.contains "\.nix$" name))
          ];
        in
        {
          name = dir;
          value =
            if nixFiles == [ ] then
              mkModules type "${root}/${dir}"
            else
              {
                imports = lib'.pipe "${root}/${dir}" [
                  lib'.findNixFilesRec
                  (map (mkModule type))
                  (builtins.filter (x: x.imports != [ ]))
                ];
              };
        }
      ))
      builtins.listToAttrs
    ];
in
{
  apps = lib'.genSystems (
    { lib, pkgs, ... }:
    lib.mapDir' ./apps (
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

  nixosConfigurations = lib'.mapDir (
    host: path:
    inputs'.linux.nixpkgs.lib.nixosSystem {
      specialArgs.inputs = inputs'.linux;
      modules = lib'.findNixFilesRec path ++ [ { networking.hostName = host; } ];
    }
  ) ./hosts/nixos;

  darwinConfigurations = lib'.mapDir (
    host: path:
    inputs'.darwin.nix-darwin.lib.darwinSystem {
      specialArgs.inputs = inputs'.darwin;
      modules = lib'.findNixFilesRec path ++ [ { networking.hostName = host; } ];
    }
  ) ./hosts/darwin;

  homeConfigurations = lib'.mapDir (
    name: path:
    let
      expr = import path;
      eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
      system = eval.nixpkgs.hostPlatform;
    in
    inputs'.linux.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs.inputs = inputs'.linux;
      pkgs = inputs'.linux.nixpkgs.legacyPackages.${system};
      modules = lib'.findNixFilesRec path ++ [
        {
          options.nixpkgs.hostPlatform = inputs'.linux.nixpkgs.lib.mkOption {
            apply = inputs'.linux.nixpkgs.lib.systems.elaborate;
          };
        }
      ];
    }
  ) ./hosts/home;

  packages = {
    aarch64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.aarch64-linux.nixos-rebuild;
    x86_64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.x86_64-linux.nixos-rebuild;

    aarch64-darwin.darwin-rebuild = inputs.nix-darwin_darwin.packages.aarch64-darwin.darwin-rebuild;

    aarch64-linux.home-manager = inputs.home-manager_linux.packages.aarch64-linux.home-manager;
    x86_64-linux.home-manager = inputs.home-manager_linux.packages.x86_64-linux.home-manager;
  };
}
