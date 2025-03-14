{ pkgs, ... }@args:
let
  bold = ''\[\e[1m\]'';
  dim = ''\[\e[90m\]'';
  reset = ''\[\e[0m\]'';
  highlighted = x: ''${bold}${dim}${x}${reset}'';
in
{
  self.bash = {
    PS1 = highlighted ''\h:\W$(prompt_info) \$ '';
    PS2 = highlighted "> ";
    PS3 = "#? ";
    PS4 = highlighted ''+ ''${BASH_SOURCE:-}:''${FUNCNAME[0]:-}:''${LINENO:-}: '';

    variables = {
      HISTCONTROL = "ignoreboth";
      HISTSIZE = 100000;
    };

    aliases = {
      "-" = "cd -";
      ".." = "cd .. && pwd";
      "?" = "echo $?";
    };

    functions = {
      "+" = ''
        "$@"
      '';

      "." = ''
        if [ $# -eq 0 ]; then
          local root
          if root=$(${args.lib.getExe pkgs.git} rev-parse --show-toplevel); then
            cd "$root" && pwd
          fi
        else
          builtin . "$@"
        fi
      '';

      rederr = ''
        (
          set -o pipefail
          "$@" 2>&1 >&3 |
          sed $'s/.*/\e[31m&\e[m/' >&2
        ) 3>&1
      '';
    };

    promptCommand = {
      ensureNewline = ''
        local y
        if [[ $- != *x* ]]; then
          IFS='[;' read -sdR -p $'\e[6n' _ _ y
          [[ "$y" = 1 ]] || printf '\e[7m%%\e[27m\n'
        fi
      '';
    };
  };
}
