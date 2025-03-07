{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.self.homebrew;

  taps = map (name: ''tap "${name}"'') (builtins.attrNames cfg.taps);
  brews = map (name: ''brew "${name}"'') cfg.brews;
  casks = map (name: ''cask "${name}", greedy: true'') cfg.casks;
  mas = map (id: ''mas "${toString id}", id: ${toString id}'') (builtins.attrValues cfg.mas);

  brewfile = pkgs.writeText "Brewfile" ''
    cask_args no_quarantine: true
    ${lib.concatLines (taps ++ brews ++ casks ++ mas)}
  '';
in
{
  self.homebrew.brews = lib.optional (cfg.mas != { }) "homebrew/core/mas";

  self.scripts.install."13-homebrew-bundle".text = ''
    HOMEBREW_NO_AUTO_UPDATE=1 \
    HOMEBREW_NO_INSTALL_FROM_API=1 \
    ${cfg.prefix}/bin/brew bundle \
        --file ${brewfile} \
        --cleanup --quiet
  '';
}
