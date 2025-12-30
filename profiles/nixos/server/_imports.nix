{ inputs, ... }:
{
  imports = [ (inputs.self + "/profiles/nixos/any-extra") ];
}
