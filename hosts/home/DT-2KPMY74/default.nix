{ inputs, ... }:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/desktop")
  ];

  _module.args.osConfig.networking.hostName = "DT-2KPMY74";

  nixpkgs.hostPlatform = "x86_64-linux";

  home.stateVersion = "24.11";
  home.username = "janvitturi";
  home.homeDirectory = "/home/janvitturi";

  self.backup.enable = false;
  self.sudo-passwordless.path = "/usr/bin/sudo";
}
