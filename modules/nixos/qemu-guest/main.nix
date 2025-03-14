args: {
  imports = [ "${args.inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = [
    # USB
    "uhci_hcd"
    "ehci_pci"

    # SATA
    "ahci"

    # CD-ROM
    "sr_mod"
  ];
}
