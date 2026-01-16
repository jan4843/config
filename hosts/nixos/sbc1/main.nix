{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/sbc")
  ];

  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Mon 04:00";
}
