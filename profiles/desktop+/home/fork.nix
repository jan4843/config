{ config, ... }:
{
  self.homebrew.casks = [ "fork" ];

  targets.darwin.defaults."com.DanPristupov.Fork" = {
    defaultSourceFolder = "${config.home.homeDirectory}/Developer";
    diffShowHiddenSymbols = true;
  };
}
