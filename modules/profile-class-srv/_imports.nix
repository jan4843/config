{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profile-hardware-qemu
        profile-lan
        profile-server
      ];
    };
}
