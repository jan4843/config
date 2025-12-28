{ config, lib, ... }:
let
  functions = lib.mapAttrs' (name: value: {
    name = "_command_not_found_${name}";
    inherit value;
  }) config.self.bash.commandNotFound;
in
{
  self.bash = lib.mkIf (functions != { }) {
    functions = functions // {
      command_not_found_handle = ''
        local f e
        for f in ${lib.escapeShellArg (builtins.attrNames functions)}; do
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
