inputs: tag:
let
  lib = inputs."nixpkgs_${tag}".lib;

  untaggedInputs = lib.filterAttrs (name: _: !lib.hasInfix "_" name) inputs;

  taggedInputs = lib.mapAttrs' (name: value: {
    name = lib.removeSuffix "_${tag}" name;
    inherit value;
  }) (lib.filterAttrs (name: _: lib.hasSuffix "_${tag}" name) inputs);
in
untaggedInputs // taggedInputs
