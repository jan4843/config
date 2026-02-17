{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/server")
    inputs.self.nixosModules.zfs
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "hvx1";
  system.stateVersion = "25.11";
  self.autoupgrade.schedule = "Sun 00:00";

  self.zfs.datasets = {
    "tank/tmp".snapshots = { };
  };
}
