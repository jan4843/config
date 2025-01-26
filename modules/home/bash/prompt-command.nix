{ config, lib, ... }:
let
  functions = lib.mapAttrs' (name: value: {
    name = "_prompt_command_${name}";
    inherit value;
  }) config.self.bash.promptCommand;
in
{
  self.bash = lib.mkIf (functions != { }) {
    inherit functions;
    profile = ''
      PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND; }${builtins.concatStringsSep "; " (builtins.attrNames functions)}"
    '';
  };
}
