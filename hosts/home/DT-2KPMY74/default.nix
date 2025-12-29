{ inputs, lib, ... }:
{
  imports =
    lib.self.siblingsOf ./default.nix
    ++ (with inputs.self.homeModules; [
      profile-desktop-base
    ]);

  nixpkgs.hostPlatform = "x86_64-linux";
  home.stateVersion = "24.11";
  home.username = "janvitturi";
  home.homeDirectory = "/home/janvitturi";

  self.backup.enable = false;
}
