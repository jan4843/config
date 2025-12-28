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
      config.nix.package
      config.systemd.package
      coreutils
      nixos-rebuild
    ];
    script = ''
      nix-collect-garbage --delete-old
      nix-store --optimise

      nixos-rebuild switch --flake ${lib.escapeShellArg "${config.self.autoupgrade.flakeref}#${config.networking.hostName}"}

      booted=$(readlink   /run/booted-system/{initrd,kernel,kernel-modules})
      current=$(readlink /run/current-system/{initrd,kernel,kernel-modules})
      [ "$booted" = "$current" ] || reboot
    '';
  };
}
