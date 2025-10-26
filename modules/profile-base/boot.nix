{
  nixos =
    { config, ... }:
    {
      boot.loader = {
        timeout = 1;

        systemd-boot.enable = !config.boot.loader.generic-extlinux-compatible.enable;
        efi.canTouchEfiVariables = true;

        generic-extlinux-compatible.configurationLimit = 8;
        systemd-boot.configurationLimit = 8;
      };
    };
}
