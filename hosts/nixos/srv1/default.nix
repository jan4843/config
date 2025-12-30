{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/srv")
  ];

  system.stateVersion = "24.11";

  self.autoupgrade.schedule = "Sat 04:00";
}
