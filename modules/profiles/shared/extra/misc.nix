{
  home-manager =
    { lib, pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          curlie
          magic-wormhole
          pdfgrep
          speedtest-go
        ]
        ++ lib.optionals pkgs.hostPlatform.isLinux [
          mame-tools
        ];
    };
}
