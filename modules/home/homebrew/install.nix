{ pkgs, ... }@args:
let
  inputs' = import ./_inputs;

  prefix = args.lib.escapeShellArg args.config.self.homebrew.prefix;
in
{
  self.scripts.check.homebrew.text = ''
    if [ -e ${prefix} ] && ! [ -e ${prefix}/.nix ]; then
      echo "${prefix}: existing installation not managed by nix"
      exit 1
    fi
  '';

  self.scripts.install."11-homebrew-bundle" = {
    path = [ "darwin" ];
    text = ''
      install() (
        sudo ${pkgs.rsync}/bin/rsync \
            --archive \
            --owner --group --chown=$(id -u):$(id -g) \
            --perms --chmod=u+w \
            ${inputs'.homebrew}/ ${prefix}

        mkdir -p ${prefix}/.nix
        cd ${inputs'.homebrew}
        echo ${inputs'.homebrew.rev} > ${prefix}/.nix/rev
        find . ! -type d > ${prefix}/.nix/files
      )

      uninstall() (
        cd ${prefix} 2>/dev/null || return 0
        cat .nix/files | tr '\n' '\0' | xargs --null rm -f
        rm -rf Library/Homebrew/vendor/portable-ruby
      )

      rev=$(cat ${prefix}/.nix/rev 2>/dev/null || :)
      if [ "$rev" != ${inputs'.homebrew.rev} ]; then
        uninstall
        install
      fi
    '';
  };
}
