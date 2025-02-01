{ config, lib, ... }:
{
  self.scripts.install.flatpak = {
    text = ''
      set -e

      export PATH=/usr/bin

      flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

      set -- ${lib.escapeShellArgs config.self.flatpak.apps}
      if [ $# -gt 0 ]; then
        flatpak --user --noninteractive install --or-update --app "$@"
      fi

      want=$*
      set --
      for app in $(flatpak --user list --app --columns=application); do
        case " $want " in *" $app "*) continue;; esac
        set -- "$@" "$app"
      done
      if [ $# -gt 0 ]; then
        flatpak --user --noninteractive uninstall --app "$@"
      fi
      flatpak --user --noninteractive uninstall --unused
    '';
  };
}
