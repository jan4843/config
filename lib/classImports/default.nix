{ lib, ... }:
args: base:
let
  import' =
    subdir:
    lib.optionalAttrs (builtins.pathExists (base + "/${subdir}")) {
      imports = [ (base + "/${subdir}") ];
    };
in
if args._class == "darwin" then
  import' "darwin" // { homeConfig = import' "home"; }
else if args._class == "nixos" then
  import' "nixos" // { homeConfig = import' "home"; }
else if args._class == "homeManager" then
  import' "home"
else
  abort "unknown module class"
