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
rec {
  imports = [ inputs.self.homeModules.tailscale ];
  
  self.tailscale.authKeyFile = lib.mkDefault config.self.sideband."self.tailscale.authKey".path;
  self.sideband."self.tailscale.authKey".enable =
    config.self.tailscale.authKeyFile == config.self.sideband."self.tailscale.authKey".path;

  home.packages = [ pkgs.tailscale ];

  home.shellAliases.tailscale = "tailscale --socket=${socketPath}";

  systemd.user.sessionVariables = home.sessionVariables;
  home.sessionVariables = {
    ALL_PROXY = "socks5://${proxyAddress}";
    http_roxy = "http://${proxyAddress}";
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

      ExecStartPost = lib.escapeShellArgs (
        lib.flatten [
          "${pkgs.tailscale}/bin/tailscale"
          "--socket=${socketPath}"
          "up"
          "--auth-key=file:${config.self.tailscale.authKeyFile}"
          (map (tag: "--advertise-tags=tag:${tag}") config.self.tailscale.tags)
          config.self.tailscale.upFlags
        ]
      );
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  self.vscode.settings."tailscale.socketPath" = socketPath;
}
