{ pkgs, ... }:
{
  self.homebrew.casks = [ "tailscale-app" ];

  self.open-at-login.tailscale.appPath = "/Applications/Tailscale.app";

  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-marketplace; [
      tailscale.vscode-tailscale
    ];

    userSettings = {
      "tailscale.portDiscovery.enabled" = false;
      "tailscale.ssh.defaultUsername" = "root";
    };
  };

  targets.darwin.defaults."io.tailscale.ipn.macsys" = {
    HideDockIcon = true;
  };
}
