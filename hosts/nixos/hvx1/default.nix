{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    _server
    zfs
  ];

  networking.hostName = "hvx1";
  system.stateVersion = "25.11";
  self.autoupgrade.schedule = "Sun 00:00";

  fileSystems."/".fsType = "ext2";

  self.zfs.datasets = {
    "tank/tmp".snapshots = { };
  };
}
