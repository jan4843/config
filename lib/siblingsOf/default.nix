{ lib, ... }:
file:
let
  root = dirOf file;
in
lib.pipe root [
  builtins.readDir
  (builtins.mapAttrs (file: type: if type == "directory" then "${file}/default.nix" else file))
  builtins.attrValues
  (builtins.filter (lib.hasSuffix ".nix"))
  (map (file: root + "/${file}"))
  (builtins.filter builtins.pathExists)
  (builtins.filter (path: path != file))
]
