inputs:
let
  lib = {
    pipe = builtins.foldl' (x: f: f x);

    flatten = x: if builtins.isList x then builtins.concatMap lib.flatten x else [ x ];

    contains = infix: content: builtins.length (builtins.split infix content) > 1;

    mapDir =
      fn: dir:
      lib.pipe dir [
        builtins.readDir
        builtins.attrNames
        (map (name: {
          inherit name;
          value = fn name /.${dir}/${name};
        }))
        builtins.listToAttrs
      ];

    collectFiles =
      dir:
      lib.pipe dir [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (x: !lib.contains "^[.]" x))
        (map (x: /.${dir}/${x}))
        (map (x: if builtins.pathExists "${x}/" then lib.collectFiles x else x))
        lib.flatten
      ];
  };

  mkInputs =
    platform:
    lib.pipe inputs [
      builtins.attrNames
      (builtins.filter (x: lib.contains "_${platform}" x || !lib.contains "_" x))
      (map (name: {
        name = builtins.replaceStrings [ "_${platform}" ] [ "" ] name;
        value = inputs.${name};
      }))
      builtins.listToAttrs
    ];

  mkModules =
    root:
    let
      modules = lib.mapDir (name: path: {
        __toString = _: toString path;
        imports = lib.collectFiles path;
      }) root;
    in
    modules
    // {
      default = {
        __toString = modules.default.__toString;
        imports =
          modules.default.imports or [ ]
          ++ lib.pipe modules [
            builtins.attrValues
            (map (x: x.imports))
            lib.flatten
            (builtins.filter (x: builtins.baseNameOf x == "default.nix"))
          ]
          ++ [
            (args: {
              options.__toString = args.lib.mkOption { };
              config.__toString = args.lib.mkForce null;
            })
          ];
      };
    };
in
{
  darwinConfigurations = lib.mapDir (
    name: path:
    inputs.nix-darwin_darwin.lib.darwinSystem {
      specialArgs.inputs = mkInputs "darwin";
      modules = lib.collectFiles path;
    }
  ) ./hosts/darwin;

  nixosConfigurations = lib.mapDir (
    name: path:
    inputs.nixpkgs_linux.lib.nixosSystem {
      specialArgs.inputs = mkInputs "linux";
      modules = lib.collectFiles path;
    }
  ) ./hosts/nixos;

  homeConfigurations = lib.mapDir (
    name: path:
    let
      expr = import path;
      eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
      system = eval.nixpkgs.hostPlatform;
    in
    inputs.home-manager_linux.lib.homeManagerConfiguration {
      extraSpecialArgs.inputs = mkInputs "linux";
      pkgs = inputs.nixpkgs_linux.legacyPackages.${system};
      modules = lib.collectFiles path ++ [
        {
          options.nixpkgs.hostPlatform = inputs.nixpkgs_linux.lib.mkOption {
            apply = inputs.nixpkgs_linux.lib.systems.elaborate;
          };
        }
      ];
    }
  ) ./hosts/home;

  darwinModules = mkModules ./modules/darwin;
  nixosModules = mkModules ./modules/nixos;
  homeModules = mkModules ./modules/home;

  packages = {
    aarch64-darwin.darwin-rebuild = inputs.nix-darwin_darwin.packages.aarch64-darwin.darwin-rebuild;
    x86_64-darwin.darwin-rebuild = inputs.nix-darwin_darwin.packages.x86_64-darwin.darwin-rebuild;

    aarch64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.aarch64-linux.nixos-rebuild;
    x86_64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.x86_64-linux.nixos-rebuild;

    aarch64-linux.home-manager = inputs.home-manager_linux.packages.aarch64-linux.home-manager;
    x86_64-linux.home-manager = inputs.home-manager_linux.packages.x86_64-linux.home-manager;
  };

  checks =
    let
      _ = builtins.deepSeq (
        { }
        // (builtins.mapAttrs (
          name: value:
          builtins.trace "checking Darwin configuration ${name}" value.config.system.build.toplevel.type
        ) inputs.self.darwinConfigurations)
        // (builtins.mapAttrs (
          name: value: builtins.trace "checking home configuration ${name}" value.activationPackage.type
        ) inputs.self.homeConfigurations)
      ) { };
    in
    {
      aarch64-darwin = _;
      x86_64-darwin = _;

      aarch64-linux = _;
      x86_64-linux = _;
    };
}
