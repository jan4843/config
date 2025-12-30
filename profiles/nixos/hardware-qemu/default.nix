{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.nixpkgs + "/nixos/modules/profiles/qemu-guest.nix")
  ];

  services.qemuGuest.enable = true;
}
