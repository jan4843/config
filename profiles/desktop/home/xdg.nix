{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  xdg.enable = true;
  xdg.autostart.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  # https://github.com/nix-community/home-manager/issues/1439#issuecomment-3374894606
  xdg.configFile."systemd/user-environment-generators/05-home-manager.sh" = {
    text = ". ${lib.escapeShellArg config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh";
    executable = true;
  };
}
