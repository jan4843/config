{ pkgs, ... }:
{
  homeConfig = {
    home.packages = [ pkgs.shpool ];

    xdg.configFile."shpool/config.toml".text = ''
      prompt_prefix = ""
    '';

    self.bash.promptInfo.shpool = ''
      printf %s "''${SHPOOL_SESSION_NAME:+t$SHPOOL_SESSION_NAME}"
    '';

    home.shellAliases = {
      t = "shpool list";
      t0 = "shpool attach --force 0";
      t1 = "shpool attach --force 1";
      t2 = "shpool attach --force 2";
      t3 = "shpool attach --force 3";
      t4 = "shpool attach --force 4";
      t5 = "shpool attach --force 5";
      t6 = "shpool attach --force 6";
      t7 = "shpool attach --force 7";
      t8 = "shpool attach --force 8";
      t9 = "shpool attach --force 9";
    };
  };
}
