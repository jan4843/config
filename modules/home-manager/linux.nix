{
  home-manager =
    { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      targets.darwin.defaults = lib.mkForce { };
      targets.genericLinux.enable = true;
      targets.genericLinux.gpu.enable = false;
    };
}
