{ inputs, pkgs, ... }:
{
  imports = [
    (inputs.self + "/profiles/srv")
  ];

  networking.hostName = "srv2";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Mon 04:00";

  boot.extraModprobeConfig = ''
    options usb-storage quirks=0bc2:aa14:u
  '';

  hardware.firmware = with pkgs; [
    linux-firmware
    libreelec-dvb-firmware
  ];
}
