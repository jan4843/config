args:
let
  functions = args.lib.mapAttrs' (name: value: {
    name = "_prompt_command_${name}";
    inherit value;
  }) args.config.self.bash.promptCommand;
in
{
  self.bash = args.lib.mkIf (functions != { }) {
    inherit functions;
    profile = ''
      PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND; }${builtins.concatStringsSep "; " (builtins.attrNames functions)}"
    '';
  };
}
