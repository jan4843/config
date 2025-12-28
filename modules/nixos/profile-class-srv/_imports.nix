{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    profile-hardware-qemu
    profile-lan
    profile-server
    profile-any-base
  ];
  homeConfig.imports = with inputs.self.homeModules; [
    profile-any-extra
  ];
}
