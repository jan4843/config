args:
let
  functions = args.lib.mapAttrs' (name: value: {
    name = "_command_not_found_${name}";
    inherit value;
  }) args.config.self.bash.commandNotFound;
in
{
  self.bash = args.lib.mkIf (functions != { }) {
    functions = functions // {
      command_not_found_handle = ''
        local f e
        for f in ${args.lib.escapeShellArg (builtins.attrNames functions)}; do
          "$f" "$@"
          e=$?
          if [ $e != 127 ]; then
            return $e
          fi
        done
        printf '%s: %s: %s\n' "$BASH_ARGV0" "$1" "command not found"
        return 127
      '';
    };
  };
}
