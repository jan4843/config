{ inputs, ... }:
{
  imports = [ "${inputs.self}/modules/nixos/profile-any-base/nix.nix" ];
}
