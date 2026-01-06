{
  config,
  lib,
  pkgs,
  ...
}:
let
  taps = lib.pipe config.self.homebrew.taps [
    (builtins.mapAttrs (
      name: value: ''
        mkdir -p $out/${builtins.dirOf name}
        ln -s ${value} $out/${builtins.dirOf name}/homebrew-${builtins.baseNameOf name}
      ''
    ))
    builtins.attrValues
    lib.concatLines
    (pkgs.runCommand "Taps" { })
  ];
in
lib.mkIf config.self.homebrew.enable {
  home.activation.homebrewTaps =
    lib.hm.dag.entryBetween [ "installPackages" ] [ "writeBoundary" "homebrewInstall" ]
      ''
        ${pkgs.rsync}/bin/rsync \
          --archive --delete \
          --owner --group --chown="$(id -u):$(id -g)" \
          --perms --chmod=u+w \
          ${taps}/ ${config.self.homebrew.prefix}/Library/Taps
      '';
}
