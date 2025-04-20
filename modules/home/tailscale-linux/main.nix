{ pkgs, ... }@args:
let
  socketPath = "/tmp/tailscaled.${args.config.home.username}.sock";
  proxyAddress = "127.0.0.1:1055";
in
{
  imports = [ args.inputs.self.homeModules.tailscale ];

  home.packages = [ pkgs.tailscale ];

  home.shellAliases = {
    tailscale = "tailscale --socket=${socketPath}";
    curl = "http_proxy=http://${proxyAddress} curl";
    wget = "wget -e use_proxy=yes -e http_proxy=http://${proxyAddress} -e https_proxy=http://${proxyAddress}";
  };

  systemd.user.services.tailscaled = {
    Unit = rec {
      After = [ "network-online.target" ];
      Wants = After;
      X-SwitchMethod = "keep-old";
    };

    Service = {
      Type = "notify";
      Restart = "on-failure";

      ExecStart = args.lib.escapeShellArgs [
        "${pkgs.tailscale}/bin/tailscaled"
        "--socket=${socketPath}"
        "--tun=userspace-networking"
        "--outbound-http-proxy-listen=${proxyAddress}"
        "--socks5-server=${proxyAddress}"
      ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs.vscode.userSettings."tailscale.socketPath" = socketPath;
}
