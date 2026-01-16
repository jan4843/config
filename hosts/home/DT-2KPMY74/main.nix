{ inputs, ... }:
{
  imports = [
    (inputs.self + "/profiles/desktop")
  ];

  _module.args.osConfig.networking.hostName = "DT-2KPMY74";

  home.stateVersion = "24.11";
  home.username = "janvitturi";
  home.homeDirectory = "/home/janvitturi";

  self.backup.enable = false;
  self.sudo-passwordless.path = "/usr/bin/sudo";
}
