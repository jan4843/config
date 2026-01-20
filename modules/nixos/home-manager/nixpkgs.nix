{ extendModules, lib, ... }:
let
  original = extendModules {
    modules = lib.singleton {
      disabledModules = [ { key = "_homeNixpkgs"; } ];
    };
  };
in
{
  imports = lib.singleton {
    key = "_homeNixpkgs";

    config = {
      homeConfig.nixpkgs = {
        config = lib.mkForce null;
        overlays = lib.mkForce null;
      };

      nixpkgs = {
        config = original.config.homeConfig.nixpkgs.config;
        overlays = original.config.homeConfig.nixpkgs.overlays;
      };
    };
  };

  homeConfig.nixpkgs = {
    config = { };
    overlays = [ ];
  };
}
