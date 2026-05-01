{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.self.homebrew;

  brew-wrapper = pkgs.writeScript "brew" ''
    #!/bin/sh
    HOMEBREW_NO_AUTO_UPDATE=1 \
    HOMEBREW_NO_INSTALL_FROM_API=1 \
    HOMEBREW_REPOSITORY=${cfg.prefix} \
    HOMEBREW_PREFIX=${cfg.prefix} \
    HOMEBREW_CELLAR=${cfg.prefix}/Cellar \
    exec ${cfg.prefix}/bin/.brew-wrapped "$@"
  '';

  install = ''
    /usr/bin/sudo ${pkgs.rsync}/bin/rsync \
      --archive \
      --owner --group --chown="$(id -u):$(id -g)" \
      --perms --chmod=u+w \
      ${cfg.package}/ ${cfg.prefix}
    cd ${cfg.prefix}
    mv bin/brew bin/.brew-wrapped
    ln -s ${brew-wrapper} bin/brew
    mkdir -p .nix
    ( cd ${cfg.package} && find . ! -type d ) > .nix/files
    echo ${cfg.package.rev} > .nix/rev
  '';

  uninstall = ''
    if cd ${cfg.prefix} 2>/dev/null; then
      xargs rm -f < .nix/files
      rm -f bin/.brew-wrapped
    fi
  '';
in
lib.mkIf config.self.homebrew.enable {
  home.activation.homebrewCheck = lib.hm.dag.entryBefore [ "checkFilesChanged" ] ''
    if [ -e ${cfg.prefix} ] && ! [ -e ${cfg.prefix}/.nix/rev ]; then
      printf >&2 '\e[1;31m%s\e[0m\n' "error: homebrew installation already present but not managed by nix"
      exit 2
    fi
  '';

  home.activation.homebrewInstall =
    lib.hm.dag.entryBetween [ "installPackages" ] [ "writeBoundary" ]
      ''
        if [ "$(cat ${cfg.prefix}/.nix/rev 2>/dev/null)" != ${cfg.package.rev} ]; then
          ( ${uninstall} )
          ( ${install} )
        fi
      '';
}
