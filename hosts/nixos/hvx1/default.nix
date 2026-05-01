{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules."@server"
    inputs.self.nixosModules.zfs
  ];

  networking.hostName = "hvx1";
  system.stateVersion = "25.11";
  self.autoupgrade.schedule = "Sun 00:00";

  self.zfs.datasets = {
    "tank/tmp".snapshots = { };
  };
}
