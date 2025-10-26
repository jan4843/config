{
  nixos =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        profile-hardware-pi4
        profile-lan
        profile-server
      ];
    };
}
