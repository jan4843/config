{ inputs, ... }:
{
  imports = [ "${inputs.nixpkgs}/nixos/modules/profiles/qemu-guest.nix" ];

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
