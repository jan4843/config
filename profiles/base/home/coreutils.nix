{ pkgs, ... }:
{
  home.shellAliases = {
    cp = "cp -v";
    mv = "mv -v";
    rm = "rm -v";
    ln = "ln -v";
    mkdir = "mkdir -v";
    rmdir = "rmdir -v";
    chmod = "chmod -vv";
    chown = "chown -vv";
    chgrp = "chgrp -vv";

    ls = if pkgs.stdenv.hostPlatform.isDarwin then "ls -AFh -G" else "ls -AFhv --color=auto";

    "-- -x" = "chmod -x";
    "+x" = "chmod +x";
  };
}
