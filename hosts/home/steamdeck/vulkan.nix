{ pkgs, ... }@args:
let
  driversDir = "${pkgs.mesa}/share/vulkan/icd.d";
  drivers = args.lib.pipe driversDir [
    builtins.readDir
    builtins.attrNames
    (map (f: "${driversDir}/${f}"))
  ];
  vars.VK_ADD_DRIVER_FILES = args.lib.concatStringsSep ":" drivers;
in
{
  home.sessionVariables = vars;
  systemd.user.sessionVariables = vars;
}
