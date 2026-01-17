{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/sbc")
  ];

  networking.hostName = "sbc2";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Wed 04:00";
  hardware.raspberry-pi."4".tv-hat.enable = true;
}
