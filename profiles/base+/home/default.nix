{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = inputs.self.lib.siblingsOf ./default.nix ++ [
    (inputs.self + "/profiles/base")
  ];

  home.packages =
    with pkgs;
    [
      curlie
      magic-wormhole
      pdfgrep
      speedtest-go
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      bandwhich
      mame-tools
    ];
}
