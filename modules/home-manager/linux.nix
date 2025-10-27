{
  home-manager =
    { lib, pkgs, ... }:
    lib.mkIf pkgs.hostPlatform.isLinux {
      targets.darwin.defaults = lib.mkForce { };
      targets.genericLinux.enable = true;
    };
}
