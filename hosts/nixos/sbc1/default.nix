{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/sbc")
  ];

  networking.hostName = "sbc1";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Mon 04:00";
}
