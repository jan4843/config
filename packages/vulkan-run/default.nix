{ lib, pkgs, ... }:
let
  driversDir = "${pkgs.mesa.drivers}/share/vulkan/icd.d";
  drivers = lib.pipe driversDir [
    builtins.readDir
    builtins.attrNames
    (map (f: "${driversDir}/${f}"))
  ];
in
pkgs.writeScriptBin "vulkan-run" ''
  VK_ADD_DRIVER_FILES="${lib.concatStringsSep ":" drivers}''${VK_ADD_DRIVER_FILES:+:$VK_ADD_DRIVER_FILES}" \
  exec "$@"
''
