{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  mas = lib.getExe pkgs.nixpkgs-unstable.mas;
in
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  options.self.mas = lib.mkOption {
    type = lib.types.listOf lib.types.ints.unsigned;
    default = [ ];
  };

  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    home.activation.mas = lib.hm.dag.entryBetween [ "installPackages" ] [ "writeBoundary" ] ''
      mas_want=(${toString config.self.mas})
      mapfile -t mas_got < <(${mas} list | ${pkgs.gawk}/bin/awk '{print $1}')

      mas_install=()
      mas_uninstall=()

      for w in "''${mas_want[@]}"; do
        got=0
        for g in "''${mas_got[@]}"; do
          if [[ $g = $w ]]; then
            got=1
            break
          fi
        done
        if [[ $got = 0 ]]; then
          mas_install+=( $w )
        fi
      done

      for g in "''${mas_got[@]}"; do
        want=0
        for w in "''${mas_want[@]}"; do
          if [[ $g = $w ]]; then
            want=1
            break
          fi
        done
        if [[ $want = 0 ]]; then
          mas_uninstall+=( $g )
        fi
      done

      [[ ''${#mas_install[@]} -eq 0 ]]   || ${mas} install ''${mas_install[@]}
      [[ ''${#mas_uninstall[@]} -eq 0 ]] || ${mas} uninstall ''${mas_uninstall[@]}
    '';
  };
}
