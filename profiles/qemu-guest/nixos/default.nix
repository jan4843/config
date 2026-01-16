{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.nixpkgs + "/nixos/modules/profiles/qemu-guest.nix")
  ];

  services.qemuGuest.enable = true;
}
