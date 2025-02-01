{ lib, ... }:
{
  options.self.flatpak = {
    apps = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching "[a-zA-Z0-9.]+");
      default = [ ];
    };
  };
}
