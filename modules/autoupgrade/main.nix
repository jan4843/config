{
  nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      systemd.services.autoupgrade = {
        startAt = config.self.autoupgrade.schedule;
        path = with pkgs; [
          config.systemd.package
          coreutils
          nixos-rebuild
        ];
        script = ''
          nixos-rebuild switch --flake ${lib.escapeShellArg "${config.self.autoupgrade.flakeref}#${config.networking.hostName}"}

          booted=$(readlink  /run/booted-system/{initrd,kernel,kernel-modules})
          current=$(readlink /run/booted-system/{initrd,kernel,kernel-modules})
          [ "$booted" = "$current" ] || reboot
        '';
      };
    };
}
