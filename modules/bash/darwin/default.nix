{ config, pkgs, ... }:
let
  pkg = pkgs.bashInteractive;
  shellPath = "/run/current-system/sw${pkg.shellPath}";
in
{
  environment = {
    shells = [ shellPath ];
    systemPackages = [ pkg ];
  };

  system.activationScripts.postActivation.text = ''
    if [ "$(dscl . -read ${config.system.primaryUserHome} UserShell)" != "UserShell: ${shellPath}" ]; then
      echo "setting shell..." >&2
      dscl . -create ${config.system.primaryUserHome} UserShell ${shellPath}
    fi
  '';
}
