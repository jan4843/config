{
  home-manager =
    { lib, pkgs, ... }:
    {
      home.packages =
        [ ]
        ++ lib.optional pkgs.hostPlatform.isDarwin pkgs.darwin.trash
        ++ lib.optional pkgs.hostPlatform.isLinux pkgs.trash-cli;

      home.shellAliases.del = "trash -v";
    };
}
