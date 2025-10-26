inputs:
let
  lib' = {
    pipe = builtins.foldl' (x: f: f x);

    flatten =
      xs: builtins.foldl' (acc: x: acc ++ (if builtins.isList x then lib'.flatten x else [ x ])) [ ] xs;

    contains = infix: string: builtins.length (builtins.split infix string) > 1;

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

    findNixFilesRec =
      dir:
      lib'.pipe dir [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (file: !lib'.contains "^\\." file))
        (map (
          file:
          if builtins.pathExists "${dir}/${file}/" then
            lib'.findNixFilesRec /.${dir}/${file}
          else
            /.${dir}/${file}
        ))
        lib'.flatten
        (builtins.filter (path: lib'.contains "\.nix$" (builtins.baseNameOf path)))
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
        imports = [ expr.${type} or { } ];
      };

  mkModules =
    type:
    lib'.pipe ./modules [
      builtins.readDir
      builtins.attrNames
      (map (module: {
        name = module;
        value.imports = lib'.pipe ./modules/${module} [
          lib'.findNixFilesRec
          (map (mkModule type))
          (builtins.filter (x: x.imports != [ { } ]))
        ];
      }))
      (builtins.filter (x: x.value.imports != [ ]))
      builtins.listToAttrs
    ];
in
{
  nixosModules = mkModules "nixos";
  darwinModules = mkModules "nix-darwin";
  homeModules = mkModules "home-manager";

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
