inputs:
let
  flakeExposed = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];
  pipe = builtins.foldl' (x: f: f x);
  contains = infix: string: builtins.length (builtins.split infix string) > 1;
  mapDir =
    fn: dir:
    pipe dir [
      builtins.readDir
      builtins.attrNames
      (map (name: {
        inherit name;
        value = fn name (dir + "/${name}");
      }))
      builtins.listToAttrs
    ];
  nixFiles =
    path:
    pipe path [
      builtins.readDir
      builtins.attrNames
      (builtins.filter (contains ''^[^_].*\.nix$''))
      (map (file: path + "/${file}"))
    ];
  filterInputs =
    system:
    let
      suffix = if contains "darwin" system then "darwin" else "linux";
    in
    pipe inputs [
      builtins.attrNames
      (builtins.filter (name: contains "_${suffix}$" name || !contains "_" name))
      (map (name: {
        name = builtins.replaceStrings [ "_${suffix}" ] [ "" ] name;
        value = inputs.${name};
      }))
      builtins.listToAttrs
    ];
  mkModules =
    class:
    mapDir (name: path: {
      imports = if (builtins.pathExists (path + "/${class}")) then nixFiles (path + "/${class}") else [ ];
      config =
        if class != "home" then { homeConfig.imports = [ inputs.self.homeModules.${name} ]; } else { };
    }) ./modules;
  genSystems =
    fn:
    pipe flakeExposed [
      (map (system: {
        name = system;
        value = fn system;
      }))
      builtins.listToAttrs
    ];
in
{
  inherit inputs;

  nixosModules = mkModules "nixos";
  darwinModules = mkModules "darwin";
  homeModules = mkModules "home";

  nixosConfigurations = mapDir (
    name: path:
    inputs.nixpkgs_linux.lib.nixosSystem {
      specialArgs.inputs = filterInputs "linux";
      modules = nixFiles path;
    }
  ) ./hosts/nixos;

  darwinConfigurations = mapDir (
    name: path:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs.inputs = filterInputs "darwin";
      modules = nixFiles path;
    }
  ) ./hosts/darwin;

  homeConfigurations = mapDir (
    name: path:
    let
      system = eval.nixpkgs.hostPlatform;
      eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
      expr = import path;
      inputs' = filterInputs system;
      lib' = inputs'.nixpkgs.lib;
    in
    inputs'.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs'.nixpkgs.legacyPackages.${system};
      extraSpecialArgs.inputs = inputs';
      modules = nixFiles path ++ [
        { options.nixpkgs.hostPlatform = lib'.mkOption { apply = lib'.systems.elaborate; }; }
      ];
    }
  ) ./hosts/home;

  apps = genSystems (
    system:
    let
      inputs' = filterInputs system;
      pkgs = inputs'.nixpkgs.legacyPackages.${system};
    in
    mapDir (name: path: {
      type = "app";
      meta.description = name;
      program = pkgs.lib.getExe (pkgs.callPackage path { inputs = inputs'; });
    }) ./apps
  );

  checks = genSystems (
    system:
    builtins.deepSeq (
      (builtins.mapAttrs (
        name: value:
        builtins.trace "checking darwin configuration ${name}" value.config.system.build.toplevel.outPath
      ) inputs.self.darwinConfigurations)
      // (builtins.mapAttrs (
        name: value: builtins.trace "checking home configuration ${name}" value.activationPackage.outPath
      ) inputs.self.homeConfigurations)
    ) { }
  );
}
