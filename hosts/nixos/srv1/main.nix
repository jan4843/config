{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/srv")
  ];

  system.stateVersion = "24.11";

  self.autoupgrade.schedule = "Sat 04:00";
}
