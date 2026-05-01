{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.self.homeModules."@base"
  ];

  home.packages =
    with pkgs;
    [
      curlie
      magic-wormhole
      pdfgrep
      speedtest-go
      xq-xml
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      bandwhich
      mame-tools
    ];
}
