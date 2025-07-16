{ pkgs, ... }@args:
{
  home.packages =
    [ ]
    ++ args.lib.optional pkgs.hostPlatform.isDarwin pkgs.darwin.trash
    ++ args.lib.optional pkgs.hostPlatform.isLinux pkgs.trash-cli;

  home.shellAliases.del = "trash -v";
}
