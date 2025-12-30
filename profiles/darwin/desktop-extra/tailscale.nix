{ casks, ... }:
{
  ois.homebrew.casks = [ casks.tailscale-app ];

  homeConfig.imports = [
    (
      { vscode-marketplace, ... }:
      {
        self.open-at-login.tailscale.appPath = "/Applications/Tailscale.app";

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
    )
  ];
}
