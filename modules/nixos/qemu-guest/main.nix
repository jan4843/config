args: {
  imports = [ "${args.inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.qemuGuest.enable = true;
}
