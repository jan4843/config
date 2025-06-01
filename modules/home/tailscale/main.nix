{ vscode-marketplace, ... }:
{
  programs.vscode.profiles.default = {
    extensions = with vscode-marketplace; [
      tailscale.vscode-tailscale
    ];

    userSettings = {
      "tailscale.portDiscovery.enabled" = false;
      "tailscale.ssh.defaultUsername" = "root";
    };
  };
}
