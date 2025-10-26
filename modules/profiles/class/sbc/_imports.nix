{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profiles.hardware.pi4
        profiles.lan
        profiles.server
      ];
    };
}
