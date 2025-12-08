{
  home-manager =
    { pkgs, ... }:
    let
      inputs'.zmx = builtins.getFlake "github:neurosnap/zmx/c15a46bb4e6aae32476c1123f8ebbf41773ba89e";
    in
    {
      home.packages = [ inputs'.zmx.packages.${pkgs.hostPlatform.system}.zmx ];

      self.bash.promptInfo.zmx = ''
        printf %s "''${ZMX_SESSION:+t$ZMX_SESSION}"
      '';

      home.shellAliases = {
        t = "zmx list";
        t- = "zmx detach";
        t0 = "zmx attach 0";
        t1 = "zmx attach 1";
        t2 = "zmx attach 2";
        t3 = "zmx attach 3";
        t4 = "zmx attach 4";
        t5 = "zmx attach 5";
        t6 = "zmx attach 6";
        t7 = "zmx attach 7";
        t8 = "zmx attach 8";
        t9 = "zmx attach 9";
      };
    };
}
