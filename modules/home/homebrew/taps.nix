{ pkgs, ... }@args:
let
  taps = args.lib.pipe args.config.self.homebrew.taps [
    (builtins.mapAttrs (
      name: value: ''
        mkdir -p $out/${builtins.dirOf name}
        ln -s ${value} $out/${builtins.dirOf name}/homebrew-${builtins.baseNameOf name}
      ''
    ))
    builtins.attrValues
    args.lib.concatLines
    (pkgs.runCommand "Taps" { })
  ];
in
{
  self.scripts.install."12-homebrew-taps" = {
    path = with pkgs; [
      coreutils
      rsync
    ];

    text = ''
      rsync \
        --archive --delete \
        --owner --group --chown=$(id -u):$(id -g) \
        --perms --chmod=u+w \
        ${taps}/ ${args.config.self.homebrew.prefix}/Library/Taps
    '';
  };
}
