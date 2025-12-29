{ inputs, lib, ... }:
{
  imports =
    lib.self.siblingsOf ./default.nix
    ++ (with inputs.self.nixosModules; [
      profile-class-srv
    ]);

  system.stateVersion = "24.11";

  self.autoupgrade.schedule = "Sat 04:00";
}
