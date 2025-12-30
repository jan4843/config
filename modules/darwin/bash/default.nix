{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  pkg = pkgs.bashInteractive;
  shellPath = "/run/current-system/sw${pkg.shellPath}";
in
{
  imports = lib.self.siblingsOf ./default.nix;

  homeConfig.imports = [ (inputs.self + "/modules/home/bash") ];

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

  homeConfig.programs.vscode.profiles.default.userSettings = {
    "terminal.integrated.defaultProfile.osx" = "bash";
    "terminal.integrated.profiles.osx".bash = {
      "source" = shellPath;
      "args" = [ "-himBHs" ];
    };
  };
}
