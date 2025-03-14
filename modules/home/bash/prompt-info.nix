args:
let
  functions = args.lib.mapAttrs' (name: value: {
    name = "_prompt_info_${name}";
    inherit value;
  }) args.config.self.bash.promptInfo;
in
{
  self.bash.functions = {
    prompt_info = ''
      local result=
      local fn=
      for fn in ${toString (builtins.attrNames functions)}; do
        local out=$($fn)
        if [ -n "$out" ]; then
          if [ -z "$result" ]; then
            result="$out"
          else
            result="$result''${2:-, }$out"
          fi
        fi
      done
      [ -z "$result" ] || printf "''${1:-(%s)}" "$result"
    '';
  } // functions;
}
