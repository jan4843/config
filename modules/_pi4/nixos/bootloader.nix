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
      { _overtakeInstallBootLoader = false; }
      (inputs.nixpkgs + "/nixos/modules/installer/sd-card/sd-image-aarch64.nix")
    ];
  };

  firmware = pkgs.runCommand "firmware" { } ''
    mkdir -p $out
    ln -s $out firmware
    ${installer.config.sdImage.populateFirmwareCommands}
  '';

  populateBootScript = pkgs.writeShellScript "populate-boot" ''
    ${pkgs.coreutils}/bin/cp -R ${firmware}/* /boot
    ${installer.config.system.build.installBootLoader} "$@"
  '';
in
{
  options._overtakeInstallBootLoader = lib.mkOption { default = true; };

  config = lib.mkIf config._overtakeInstallBootLoader {
    system.build.installBootLoader = lib.mkForce populateBootScript;
  };
}
