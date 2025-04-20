{ pkgs, ... }:
{
  hardware.firmware = with pkgs; [
    linux-firmware
    libreelec-dvb-firmware
  ];
}
