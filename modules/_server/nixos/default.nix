{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    _base-extra
    _personal
  ];

  systemd.enableEmergencyMode = false;
}
