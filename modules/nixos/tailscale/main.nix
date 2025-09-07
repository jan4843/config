{ pkgs, ... }@args:
{
  services.tailscale = {
    enable = true;
    extraDaemonFlags = [
      "--statedir=${args.config.self.persistence.path}/tailscale"
      "--state=${args.config.self.persistence.path}/tailscale/tailscaled.state"
    ];
  };

  # TODO: https://github.com/NixOS/nixpkgs/issues/438765
  services.tailscale.package = args.lib.mkIf pkgs.hostPlatform.isx86_64 (
    pkgs.tailscale.overrideAttrs (old: {
      doCheck = false;
    })
  );
}
