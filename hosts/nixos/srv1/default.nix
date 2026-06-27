{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    _srv
  ];

  networking.hostName = "srv1";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Sat 04:00";

  fileSystems."/".fsType = "ext2";
}
