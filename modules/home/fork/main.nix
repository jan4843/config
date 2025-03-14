{ config, ... }:
{
  self.homebrew.casks = with config.self.homebrew.taps."homebrew/cask".casks; [
    fork
  ];

  targets.darwin.defaults."com.DanPristupov.Fork" = {
    defaultSourceFolder = "${config.home.homeDirectory}/Developer";
    diffShowHiddenSymbols = true;
  };
}
