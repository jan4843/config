inputs: {
  inherit inputs;

  lib = (import ./lib/mapDir) (_: import) ./lib;

  nixosModules = inputs.self.lib.mapDir (_: path: path) ./modules/nixos;
  darwinModules = inputs.self.lib.mapDir (_: path: path) ./modules/darwin;
  homeModules = inputs.self.lib.mapDir (_: path: path) ./modules/home;

  nixosConfigurations = inputs.self.lib.mapDir (_: path: import path inputs) ./hosts/nixos;
  darwinConfigurations = inputs.self.lib.mapDir (_: path: import path inputs) ./hosts/darwin;
  homeConfigurations = inputs.self.lib.mapDir (_: path: import path inputs) ./hosts/home;

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
      { }
      // (builtins.mapAttrs (
        name: value:
        builtins.trace "checking Darwin configuration ${name}" value.config.system.build.toplevel.outPath
      ) inputs.self.darwinConfigurations)
      // (builtins.mapAttrs (
        name: value: builtins.trace "checking home configuration ${name}" value.activationPackage.outPath
      ) inputs.self.homeConfigurations)
    ) { }
  );
}
