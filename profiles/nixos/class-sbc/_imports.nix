{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/nixos/hardware-pi4")
    (inputs.self + "/profiles/nixos/lan")
    (inputs.self + "/profiles/nixos/server")
  ];
}
