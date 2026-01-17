{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/base")
    (inputs.self + "/profiles/qemu-guest")
    (inputs.self + "/profiles/server")
  ];

  networking.hostName = "vps1";
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Thu 04:00";
}
