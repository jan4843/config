{ inputs, ... }:
{
  imports = [ (inputs.self + "/modules/nixos/profile-any-base/sudo-passwordless.nix") ];
}
