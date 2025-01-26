{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  shellPath = "/run/current-system/sw${pkgs.bashInteractive.shellPath}";
in
lib.mkIf (config.self.bash.enable && pkgs.hostPlatform.isDarwin) {
  assertions = [
    {
      assertion = builtins.elem shellPath osConfig.environment.shells;
      message = "osConfig.environment.shells does not contain ${lib.strings.escapeNixString shellPath}";
    }
  ];

  self.scripts.write.shell = {
    path = [ "darwin" ];
    text = ''
      if [ "$(dscl . -read ${config.home.homeDirectory} UserShell)" != "UserShell: ${shellPath}" ]; then
        sudo dscl . -create ${config.home.homeDirectory} UserShell ${shellPath}
      fi
    '';
  };
}
