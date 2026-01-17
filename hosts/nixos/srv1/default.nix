{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/srv")
  ];

  networking.hostName = "srv1";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Sat 04:00";
}
