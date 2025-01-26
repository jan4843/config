{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.self.homebrew;
in
{
  imports = [
    ./install.nix
    ./taps.nix
    ./bundle.nix
    ./shell.nix
  ];

  options.self.homebrew = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pkgs.hostPlatform.isDarwin;
    };

    prefix = lib.mkOption {
      type = lib.types.path;
      default = "/opt/homebrew";
    };

    taps = lib.mkOption {
      type = lib.types.attrsOf lib.types.pathInStore;
    };

    brews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    casks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    mas = lib.mkOption {
      type = lib.types.attrsOf lib.types.ints.unsigned;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = map (formula: {
      assertion = builtins.any (tap: lib.hasPrefix "${tap}/" formula) (builtins.attrNames cfg.taps);
      message = "formula '${formula}' is missing tap prefix";
    }) (cfg.brews ++ cfg.casks);

    self.xcode-cli-tools.enable = true;

    self.homebrew.taps = {
      "homebrew/core" = inputs.homebrew-core;
      "homebrew/cask" = inputs.homebrew-cask;
      "homebrew/bundle" = inputs.homebrew-bundle;
    };
  };
}
