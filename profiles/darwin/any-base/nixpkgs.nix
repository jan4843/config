{ inputs, ... }:
{
  imports = [ (inputs.self + "/profiles/nixos/any-base/nixpkgs.nix") ];
}
