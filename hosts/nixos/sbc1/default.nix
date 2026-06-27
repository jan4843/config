{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    _sbc
  ];

  networking.hostName = "sbc1";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Mon 04:00";

  fileSystems."/".fsType = "ext4";
}
