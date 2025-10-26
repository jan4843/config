{
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

      self.git.ignore = [ "/result" ];
    };
}
