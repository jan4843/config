args:
let
  functions = args.lib.mapAttrs' (name: value: {
    name = "_pre_exec_${name}";
    inherit value;
  }) args.config.self.bash.preExec;
in
{
  self.bash = {
    functions = functions // {
      _pre_exec = ''
        [ -z "$no_pre_exec" ] || return
        [ "$1" != "no_pre_exec=1" ] || return
        ${args.lib.concatMapStringsSep "\n" (fn: ''${fn} "$1"'') (builtins.attrNames functions)}
      '';
    };

    profile = args.lib.mkAfter ''
      no_pre_exec=1
      trap '_pre_exec "$BASH_COMMAND" "$_"' DEBUG
      PROMPT_COMMAND="no_pre_exec=1; ''${PROMPT_COMMAND:+$PROMPT_COMMAND; }unset no_pre_exec"
    '';
  };
}
