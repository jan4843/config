{
  home-manager =
    { pkgs, ... }:
    let
      inputs'.zmx = builtins.getFlake "github:neurosnap/zmx/c15a46bb4e6aae32476c1123f8ebbf41773ba89e";
    in
    {
      home.packages = [ inputs'.zmx.packages.${pkgs.hostPlatform.system}.zmx ];

      self.bash.functions.t = ''
        case $# in
          0) zmx list;;
          1)
            case $1 in
              -) zmx detach;;
              *) zmx attach "$1";;
            esac;;
          *) printf '%s\n' usage: "t" "t SESSION" "t -";;
        esac
      '';

      self.bash.promptInfo.zmx = ''
        printf %s "''${ZMX_SESSION:+t$ZMX_SESSION}"
      '';
    };
}
