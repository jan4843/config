{ config, lib, ... }:
{
  self.bash.profile = lib.concatMapAttrsStringSep "\n" (name: path: ''
    _nav_${name}() {
      mapfile -t COMPREPLY < <(
        cd ${lib.escapeShellArg path} 2> /dev/null || exit 1
        compgen -S / -d -- "''${COMP_WORDS[COMP_CWORD]}"
      )
      compopt -o nospace
    }

    ${name}() { cd ${lib.escapeShellArg path}/"$1"; }

    complete -F _nav_${name} ${name}
  '') config.self.bash.nav;
}
