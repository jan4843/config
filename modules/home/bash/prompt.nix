{ config, lib, ... }:
let
  setPS =
    ps:
    lib.optionalString (config.self.bash.${ps} != null) ''
      ${ps}='${lib.strings.escape [ "'" ] config.self.bash.${ps}}'
    '';
in
{
  self.bash.profile = ''
    ${setPS "PS1"}
    ${setPS "PS2"}
    ${setPS "PS3"}
    ${setPS "PS4"}
  '';
}
