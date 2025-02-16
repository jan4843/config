{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.self.homebrew;
in
{
  assertions = map (formula: {
    assertion = builtins.any (tap: lib.hasPrefix "${tap}/" formula) (builtins.attrNames cfg.taps);
    message = "formula '${formula}' is missing tap prefix";
  }) (cfg.brews ++ cfg.casks);

  self.homebrew.taps = {
    "homebrew/core" = inputs.homebrew-core;
    "homebrew/cask" = inputs.homebrew-cask;
    "homebrew/bundle" = inputs.homebrew-bundle;
  };
}
