args:
let
  setPS =
    ps:
    args.lib.optionalString (args.config.self.bash.${ps} != null) ''
      ${ps}='${args.lib.strings.escape [ "'" ] args.config.self.bash.${ps}}'
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
