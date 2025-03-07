{
  config,
  extendModules,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  installer = extendModules {
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      { _overtakeInstallBootLoader = false; }
    ];
  };

  firmware = pkgs.runCommand "firmware" { } ''
    mkdir -p $out
    ln -s $out firmware
    ${installer.config.sdImage.populateFirmwareCommands}
  '';

  populateBootScript = pkgs.writeScript "populate-boot" ''
    #!/bin/sh
    ${pkgs.coreutils}/bin/cp -R ${firmware} /boot
    ${installer.config.system.build.installBootLoader} "$@"
  '';
in
{
  options._overtakeInstallBootLoader = lib.mkOption { default = true; };

  config = lib.mkIf config._overtakeInstallBootLoader {
    system.build.installBootLoader = lib.mkForce populateBootScript;
  };
}
