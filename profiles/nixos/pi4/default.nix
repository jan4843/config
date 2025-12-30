{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  hardware.raspberry-pi."4".leds = {
    eth.disable = true;
    act.disable = true;
    pwr.disable = true;
  };

  boot.kernelParams = [ "cgroup_enable=memory" ];
}
