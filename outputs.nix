inputs: {
  inherit inputs;

  lib = (import ./lib/mapDir) (_: import) ./lib;

  nixosModules = inputs.self.lib.mapDir (_: path: path) ./modules/nixos;
  darwinModules = inputs.self.lib.mapDir (_: path: path) ./modules/darwin;
  homeModules = inputs.self.lib.mapDir (_: path: path) ./modules/home;

  nixosConfigurations = inputs.self.lib.mapDir (
    _: path:
    inputs.nixpkgs_linux.lib.nixosSystem {
      specialArgs.inputs = inputs.self.lib.filterInputs "linux" inputs;
      modules = [ path ];
    }
  ) ./hosts/nixos;

  darwinConfigurations = inputs.self.lib.mapDir (
    _: path:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs.inputs = inputs.self.lib.filterInputs "darwin" inputs;
      modules = [ path ];
    }
  ) ./hosts/darwin;

  homeConfigurations = inputs.self.lib.mapDir (
    _: path:
    let
      system = eval.nixpkgs.hostPlatform;
      eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
      expr = import path;
      inputs' = inputs.self.lib.filterInputs system inputs;
      lib' = inputs'.nixpkgs.lib;
    in
    inputs'.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs'.nixpkgs.legacyPackages.${system};
      extraSpecialArgs.inputs = inputs';
      modules = [
        path
        { options.nixpkgs.hostPlatform = lib'.mkOption { apply = lib'.systems.elaborate; }; }
      ];
    }
  ) ./hosts/home;

  apps = inputs.self.lib.genSystems (
    system:
    let
      inputs' = inputs.self.lib.filterInputs system inputs;
      pkgs = inputs'.nixpkgs.legacyPackages.${system};
    in
    inputs.self.lib.mapDir (name: path: {
      type = "app";
      meta.description = name;
      program = pkgs.lib.getExe (pkgs.callPackage path { inputs = inputs'; });
    }) ./apps
  );

  checks = inputs.self.lib.genSystems (
    _:
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
