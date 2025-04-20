{ extendModules, pkgs, ... }@args:
let
  installer = extendModules {
    modules = [
      { _overtakeInstallBootLoader = false; }
      "${args.inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    ];
  };

  firmware = pkgs.runCommand "firmware" { } ''
    mkdir -p $out
    ln -s $out firmware
    ${installer.config.sdImage.populateFirmwareCommands}
  '';

  populateBootScript = pkgs.writeShellScript "populate-boot" ''
    ${pkgs.coreutils}/bin/cp -R ${firmware} /boot
    ${installer.config.system.build.installBootLoader} "$@"
  '';
in
{
  options._overtakeInstallBootLoader = args.lib.mkOption { default = true; };

  config = args.lib.mkIf args.config._overtakeInstallBootLoader {
    system.build.installBootLoader = args.lib.mkForce populateBootScript;
  };
}
