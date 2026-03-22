{ pkgs, ... }:
let
  # https://github.com/neurosnap/zmx/tags
  inputs'.zmx = builtins.getFlake "github:neurosnap/zmx/27bd9b8421e00cf44efbcf763a094cc06f7ff885";
in
{
  homeConfig = {
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
