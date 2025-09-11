{ pkgs, ... }@args:
{
  networking.hostName = "tmp1";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  imports = with args.inputs.self.nixosModules; [
    default

    _lan
    _server
    zfs
  ];

  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
