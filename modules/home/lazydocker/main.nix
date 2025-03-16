{ pkgs, ... }:
{
  home.packages = [ pkgs.lazydocker ];
  xdg.configFile."lazydocker/config.yml".text = builtins.toJSON {
    gui.returnImmediately = true;
    logs.timestamps = true;
  };
}
