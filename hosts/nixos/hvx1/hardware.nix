{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel-kaby-lake
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableAllFirmware = true;
}
