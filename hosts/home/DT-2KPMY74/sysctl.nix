{ config, lib, ... }:
let
  src = ".local/nix/sysctl/nix.conf";
  dest = "/etc/sysctl.d/99-nix.${config.home.username}.conf";
in
{
  home.file.${src}.text = lib.generators.toKeyValue { } {
    "fs.inotify.max_user_watches" = 1048576;
    "kernel.apparmor_restrict_unprivileged_userns" = 0;
    "kernel.yama.ptrace_scope" = 0;
  };

  home.activation.linkSysctl = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /usr/bin/sudo ln -fs ${config.home.homeDirectory}/${src} ${dest}
  '';
}
