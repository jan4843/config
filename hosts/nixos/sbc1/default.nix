{ inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
    profiles.class.sbc
  ];

  system.stateVersion = "24.11";

  self.autoupgrade.schedule = "Mon 04:00";
}
