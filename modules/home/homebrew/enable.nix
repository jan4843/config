{ inputs, ... }:
{
  self.homebrew.taps = {
    "homebrew/core" = inputs.homebrew-core;
    "homebrew/cask" = inputs.homebrew-cask;
    "homebrew/bundle" = inputs.homebrew-bundle;
  };
}
