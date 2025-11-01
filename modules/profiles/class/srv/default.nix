{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profiles.hardware.qemu
        profiles.lan
        profiles.server
      ];
    };
}
