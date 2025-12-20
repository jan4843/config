{
  home-manager =
    { pkgs, ... }:
    let
      inputs'.zmx = builtins.getFlake "github:neurosnap/zmx/d34f8d6f0a3b8ac83de35d354ea3ac1ddfd95b87";
    in
    {
      home.packages = [ inputs'.zmx.packages.${pkgs.stdenv.hostPlatform.system}.zmx ];

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
