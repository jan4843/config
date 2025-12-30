{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/nixos/base/nix.nix")
    (inputs.self + "/profiles/nixos/base/nixpkgs.nix")
    (inputs.self + "/profiles/nixos/base/sudo-passwordless.nix")

    (inputs.self + "/modules/darwin/bash")
    (inputs.self + "/modules/darwin/homebrew")
    (inputs.self + "/modules/darwin/home-manager")
  ];

  homeConfig.imports = [
    (inputs.self + "/profiles/home/base")
  ];

  time.timeZone = "Europe/Vienna";
}
