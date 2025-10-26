{
  nix-darwin =
    { casks, ... }:
    {
      ois.homebrew.casks = [ casks.fork ];
    };

  home-manager =
    { config, ... }:
    {
      targets.darwin.defaults."com.DanPristupov.Fork" = {
        defaultSourceFolder = "${config.home.homeDirectory}/Developer";
        diffShowHiddenSymbols = true;
      };
    };
}
