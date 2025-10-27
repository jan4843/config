{ inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    profiles.desktop.base
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  home.stateVersion = "24.11";
  home.username = "janvitturi";
  home.homeDirectory = "/home/janvitturi";

  self.backup.enable = false;
}
