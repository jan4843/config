{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/nixos/hardware-pi4")
    (inputs.self + "/profiles/nixos/lan")
    (inputs.self + "/profiles/nixos/server")
    (inputs.self + "/profiles/nixos/any-base")
  ];
  homeConfig.imports = [
    (inputs.self + "/profiles/home/any-extra")
  ];
}
