{ casks, homeConfig, ... }:
{
  self.homebrew.casks = [ casks.fork ];

  homeConfig.targets.darwin.defaults."com.DanPristupov.Fork" = {
    defaultSourceFolder = "${homeConfig.home.homeDirectory}/Developer";
    diffShowHiddenSymbols = true;
  };
}
