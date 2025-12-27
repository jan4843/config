rec {
  nixos = nix-darwin;

  nix-darwin =
    { config, ... }:
    {
      nix.gc.automatic = true;
      nix.settings.trusted-users = [ config.homeConfig.home.username ];
    };

  home-manager =
    { lib, pkgs, ... }:
    {
      nix.package = lib.mkDefault pkgs.nix;

      nix.settings = {
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        show-trace = true;
        warn-dirty = false;
      };

      nix.settings = {
        extra-substituters = [
          "https://jan4843.cachix.org"
          "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
          "jan4843.cachix.org-1:TDZmiqhqD9XQxvntxxQe5C3S5aToFAYLlzdqkXZ4tyo="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      nix.gc.automatic = true;

      self.git.ignore = [ "/result" ];
    };
}
