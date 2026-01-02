inputs:
let
  genSystems = import ./genSystems.nix;
in
genSystems inputs (
  { ... }:
  builtins.deepSeq (
    { }
    // (builtins.mapAttrs (
      name: value: builtins.trace "checking NixOS configuration ${name}" "nix flakes built-in"
    ) inputs.self.nixosConfigurations)
    // (builtins.mapAttrs (
      name: value:
      builtins.trace "checking Darwin configuration ${name}" value.config.system.build.toplevel.type
    ) inputs.self.darwinConfigurations)
    // (builtins.mapAttrs (
      name: value: builtins.trace "checking home configuration ${name}" value.activationPackage.type
    ) inputs.self.homeConfigurations)
  ) { }
)
