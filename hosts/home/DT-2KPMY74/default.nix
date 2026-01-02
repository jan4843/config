{ inputs, lib, ... }:
{
  imports = lib.self.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/home/desktop")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  home.stateVersion = "24.11";
  home.username = "janvitturi";
  home.homeDirectory = "/home/janvitturi";

  self.backup.enable = false;
  self.sudo-passwordless.path = "/usr/bin/sudo";
}
