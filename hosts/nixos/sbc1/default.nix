{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/sbc")
  ];

  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Mon 04:00";
}
