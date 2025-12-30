{ inputs, ... }:
{
  imports = [ (inputs.self + "/profiles/nixos/any-base/nix.nix") ];
}
