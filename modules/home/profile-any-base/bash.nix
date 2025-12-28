{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  bold = ''\[\e[1m\]'';
  dim = ''\[\e[90m\]'';
  reset = ''\[\e[0m\]'';
  highlighted = x: lib.escapeShellArg "${bold}${dim}${x}${reset}";
in
{
  imports = [ inputs.self.homeModules.bash ];

  home.file.".hushlogin".text = "";

  programs.bash.initExtra = ''
    HISTCONTROL=ignoreboth
    HISTSIZE=100000

    PS1=${highlighted ''\h:\w$(prompt_info) \$ ''}
    PS2=${highlighted ''> ''}
    PS4=${highlighted ''+ ''${BASH_SOURCE:-}:''${FUNCNAME[0]:-}:''${LINENO:-}: ''}
  '';

  programs.bash.shellAliases = {
    "-- -" = "cd -";
    ".." = "cd .. && pwd";
    "?" = "echo $?";
  };

  self.bash.functions = {
    "." = ''
      if [ $# -eq 0 ]; then
        local root
        if root=$(${lib.getExe pkgs.git} rev-parse --show-toplevel); then
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

  self.bash.nav = {
    dt = "${config.home.homeDirectory}/Desktop";
    dl = "${config.home.homeDirectory}/Downloads";
    dev = "${config.home.homeDirectory}/Developer";
    doc = "${config.home.homeDirectory}/Documents";
  };
}
