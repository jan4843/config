{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/common/cpu/intel"
    "${inputs.nixos-hardware}/common/gpu/intel/kaby-lake"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableAllFirmware = true;
}
