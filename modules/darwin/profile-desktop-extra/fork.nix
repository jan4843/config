{ casks, config, ... }:
{
  ois.homebrew.casks = [ casks.fork ];

  homeConfig = {
    targets.darwin.defaults."com.DanPristupov.Fork" = {
      defaultSourceFolder = "${config.homeConfig.home.homeDirectory}/Developer";
      diffShowHiddenSymbols = true;
    };
  };
}
