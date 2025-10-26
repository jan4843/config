{
  home-manager =
    { lib, pkgs, ... }:
    lib.mkIf (!pkgs.hostPlatform.isDarwin) {
      targets.darwin.defaults = lib.mkForce { };
    };
}
