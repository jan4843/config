{ pkgs, ... }@args:
let
  src = ".local/nix/sysctl/nix.conf";
  dest = "/etc/sysctl.d/99-nix.${args.config.home.username}.conf";
in
{
  home.file.${src}.text = args.lib.generators.toKeyValue { } {
    "fs.inotify.max_user_watches" = 1048576;
    "kernel.apparmor_restrict_unprivileged_userns" = 0;
    "kernel.yama.ptrace_scope" = 0;
  };

  self.scripts.install.sysctl = {
    path = [ pkgs.coreutils ];
    text = ''
      if ! [ -e ${dest} ]; then
        /usr/bin/sudo ln -fs ${args.config.home.homeDirectory}/${src} ${dest}
      fi
    '';
  };
}
