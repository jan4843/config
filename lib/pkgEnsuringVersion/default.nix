{ lib, ... }:
pkg: fn: builtins.seq (lib.assertMsg (fn pkg.version) "Rejected version for ${pkg.name}") pkg
