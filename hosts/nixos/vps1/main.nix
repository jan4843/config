{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/base")
    (inputs.self + "/profiles/qemu-guest")
    (inputs.self + "/profiles/server")
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.11";
  self.autoupgrade.schedule = "Thu 04:00";
}
