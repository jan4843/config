{ pkgs, ... }:
{
  home.packages = [ pkgs.bat ];

  home.shellAliases.bat = toString [
    "bat"
    "--plain"
    "--paging=never"
    "--theme=ansi"
  ];

  self.bash.functions.cat = ''
    if [ -t 0 ] && [ -t 1 ] && [ $# = 1 ] && [ -r "$1" ] && ! [ -d "$1" ]; then
      bat "$@"
    else
      command cat "$@"
    fi
  '';
}
