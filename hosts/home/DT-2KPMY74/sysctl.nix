{ pkgs, ... }@args:
{
  home.file.".nix/sysctl/nix.conf".text = ''
    fs.inotify.max_user_watches=1048576
    kernel.apparmor_restrict_unprivileged_userns=0
    kernel.yama.ptrace_scope=0
  '';

  self.scripts.install.sysctl = {
    path = with pkgs; [
      coreutils
    ];
    text = ''
      if ! [ -e /etc/sysctl.d/99-nix.conf ]; then
        /usr/bin/sudo ln -fs ${args.config.home.homeDirectory}/.nix/sysctl/nix.conf /etc/sysctl.d/99-nix.${args.config.home.username}.conf
      fi
    '';
  };
}
