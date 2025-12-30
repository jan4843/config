{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/nixos/hardware-qemu")
    (inputs.self + "/profiles/nixos/lan")
    (inputs.self + "/profiles/nixos/server")
  ];
}
