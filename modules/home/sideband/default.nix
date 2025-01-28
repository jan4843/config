{
  config,
  lib,
  pkgs,
  ...
}:
let
  # TODO
  root = "${config.home.homeDirectory}/.local/nix/sideband";
  expectedFiles = lib.pipe config.self.sideband [
    (lib.filterAttrs (_: v: v.enable))
    (lib.mapAttrsToList (_: v: v.path))
  ];
in
{
  self.scripts.check.sideband.text = ''
    ${pkgs.coreutils}/bin/mkdir -p ${root}

    for f in ${lib.escapeShellArgs expectedFiles}; do
      if ! [ -e "$f" ]; then
        trap 'exit 1' EXIT
        printf '%q: sideband file not found\n' "$f"
      fi
    done

    shopt -s dotglob nullglob
    for f in ${lib.escapeShellArg root}/*; do
      extraneous=1
      for expected in ${lib.escapeShellArgs expectedFiles}; do
        if [ "$f" = "$expected" ]; then
          extraneous=
          break
        fi
      done
      if [ -n "$extraneous" ]; then
        printf '%q: extraneous sideband file found\n' "$f"
      fi
    done
  '';
}
