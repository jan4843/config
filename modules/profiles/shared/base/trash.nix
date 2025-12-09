{
  home-manager =
    { lib, pkgs, ... }:
    {
      home.packages =
        [ ]
        ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin pkgs.darwin.trash
        ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.trash-cli;

      home.shellAliases.del = "trash -v";
    };
}
