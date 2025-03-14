args:
let
  cfg = args.config.self.homebrew;

  taps = map (name: ''tap "${name}"'') (builtins.attrNames cfg.taps);
  brews = map (formula: ''brew "${formula.tap}/${formula.name}"'') cfg.brews;
  casks = map (cask: ''cask "${cask.tap}/${cask.name}", greedy: true'') cfg.casks;
  mas = map (id: ''mas "${toString id}", id: ${toString id}'') (builtins.attrValues cfg.mas);
in
{
  xdg.configFile."homebrew/Brewfile".text = ''
    cask_args no_quarantine: true
    ${args.lib.concatLines (taps ++ brews ++ casks ++ mas)}
  '';

  self.homebrew.brews = args.lib.optional (cfg.mas != { }) cfg.taps."homebrew/core".formulae.mas;

  self.scripts.install."13-homebrew-bundle".text = ''
    HOMEBREW_NO_AUTO_UPDATE=1 \
    HOMEBREW_NO_INSTALL_FROM_API=1 \
    ${cfg.prefix}/bin/brew bundle \
        --file ${args.config.xdg.configFile."homebrew/Brewfile".source} \
        --cleanup --quiet
  '';
}
