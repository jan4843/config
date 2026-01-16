{
  config,
  homeConfig,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

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
      nix-collect-garbage --delete-old
      nix-store --optimise

      if nixos-rebuild switch --accept-flake-config --flake ${lib.escapeShellArg "${config.self.autoupgrade.flakeref}#${config.networking.hostName}"}; then
        booted=$(readlink   /run/booted-system/{initrd,kernel,kernel-modules})
        current=$(readlink /run/current-system/{initrd,kernel,kernel-modules})
        [ "$booted" = "$current" ] || reboot
      else
        ${homeConfig.self.push.notifyScript} "autoupgrade failed"
        exit 1
      fi
    '';
  };
}
