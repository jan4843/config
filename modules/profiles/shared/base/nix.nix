rec {
  nixos = nix-darwin;

  nix-darwin = {
    nix.gc.automatic = true;
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

      nix.gc.automatic = true;

      self.git.ignore = [ "/result" ];
    };
}
