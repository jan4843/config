{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = with inputs.self.homeModules; [
    _base
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
