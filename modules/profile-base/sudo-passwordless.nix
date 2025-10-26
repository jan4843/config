rec {
  nixos = nix-darwin;

  nix-darwin =
    { config, ... }:
    {
      security.sudo.extraConfig = ''
        ${config.homeConfig.home.username} ALL=(ALL) NOPASSWD: ALL
      '';
    };
}
