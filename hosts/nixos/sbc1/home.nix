{ pkgs, ... }@args:
{
  homeConfig.imports = with args.inputs.self.homeModules; [
    default

    profile-base

    bash
    lazydocker
    nix
    push
    python
  ];

  homeConfig.home.packages = with pkgs; [
    lsscsi
    parted
    sg3_utils
    smartmontools
    usbutils
  ];
}
