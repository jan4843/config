{ inputs, ... }:
{
  imports = [ (inputs.self + "/profiles/nixos/any-base/sudo-passwordless.nix") ];
}
