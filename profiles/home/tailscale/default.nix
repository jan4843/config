{
  self.vscode = {
    extensions = [ "tailscale.vscode-tailscale" ];
    settings = {
      "tailscale.portDiscovery.enabled" = false;
      "tailscale.ssh.defaultUsername" = "root";
    };
  };
}
