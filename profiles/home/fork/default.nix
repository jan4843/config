{ config, ... }:
{
  self.homebrew.casks = [ "homebrew/cask/fork" ];

  targets.darwin.defaults."com.DanPristupov.Fork" = {
    defaultSourceFolder = "${config.home.homeDirectory}/Developer";
    diffShowHiddenSymbols = true;
  };
}
