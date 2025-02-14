{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  socketPath = "/tmp/tailscaled.${config.home.username}.sock";
  proxyAddress = "127.0.0.1:1055";
in
{
  imports = [ inputs.self.homeModules.tailscale ];

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
    };

    Service = {
      Type = "notify";
      Restart = "on-failure";

      ExecStart = lib.escapeShellArgs [
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

  self.vscode.settings."tailscale.socketPath" = socketPath;
}
