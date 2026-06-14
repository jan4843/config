{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.self.autoupgrade = {
    flakeref = lib.mkOption {
      type = lib.types.str;
    };

    schedule = lib.mkOption {
      type = lib.types.str;
    };
  };

  config.systemd.services.autoupgrade = {
    startAt = config.self.autoupgrade.schedule;
    path = with pkgs; [
      config.nix.package
      config.systemd.package
      coreutils
      nixos-rebuild
    ];
    script = ''
      nixos-rebuild switch --accept-flake-config --flake ${lib.escapeShellArg "${config.self.autoupgrade.flakeref}#${config.networking.hostName}"}

      booted=$(readlink   /run/booted-system/{initrd,kernel,kernel-modules})
      current=$(readlink /run/current-system/{initrd,kernel,kernel-modules})
      [ "$booted" = "$current" ] || reboot
    '';
  };
}
