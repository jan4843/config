args:
let
  inputs' = import ./inputs;
in
{
  self.homebrew.taps = {
    "homebrew/core" = args.inputs.homebrew-core;
    "homebrew/cask" = args.inputs.homebrew-cask;
    "homebrew/bundle" = inputs'.homebrew-bundle;
  };
}
