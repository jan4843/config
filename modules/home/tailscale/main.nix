{ vscode-marketplace, ... }:
{
  programs.vscode = {
    extensions = with vscode-marketplace; [
      tailscale.vscode-tailscale
    ];

    userSettings = {
      "tailscale.portDiscovery.enabled" = false;
      "tailscale.ssh.defaultUsername" = "root";
    };
  };
}
