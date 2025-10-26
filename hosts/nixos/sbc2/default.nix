{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    profile-class-sbc
  ];

  system.stateVersion = "24.11";

  self.autoupgrade.schedule = "Wed 04:00";
}
