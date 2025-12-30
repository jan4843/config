{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/srv")
  ];

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
