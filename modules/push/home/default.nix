{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  ntfy = pkgs.writeShellApplication {
    name = "ntfy";
    runtimeInputs = with pkgs; [
      cacert
      curl
    ];
    text = ''
      curl -f \
        --max-time 3 \
        -H Title:${lib.escapeShellArg osConfig.networking.hostName} \
        -d "$*" \
        "https://ntfy.sh/$(<${lib.escapeShellArg config.self.push.keyFile})"
    '';
  };

  healthchecks = pkgs.writeShellApplication {
    name = "healthchecks";
    runtimeInputs = with pkgs; [
      cacert
      curl
    ];
    text = ''
      curl -f \
        --max-time 3 \
        "https://hc-ping.com/$(<${lib.escapeShellArg config.self.push.keyFile})/${lib.escapeShellArg (lib.toLower osConfig.networking.hostName)}-''${1,,}?create=1"
    '';
  };
in
{
  options.self.push = {
    keyFile = lib.mkOption {
      type = lib.types.path;
    };

    notifyScript = lib.mkOption {
      readOnly = true;
      default = lib.getExe ntfy;
    };

    pingScript = lib.mkOption {
      readOnly = true;
      default = lib.getExe healthchecks;
    };
  };

  config.home.packages = [
    ntfy
    healthchecks
  ];
}
