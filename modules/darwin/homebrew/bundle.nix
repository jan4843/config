{ config, lib, ... }:
let
  cfg = config.self.homebrew;

  taps = map (x: ''tap "${x}"'') (builtins.attrNames cfg.taps);
  brews = map (x: ''brew "${x.name}"'') cfg.brews;
  casks = map (x: ''cask "${x.name}", greedy: true'') cfg.casks;

  brewfile = builtins.toFile "Brewfile" ''
    cask_args no_quarantine: true
    ${lib.concatLines (taps ++ brews ++ casks)}
  '';
in
{
  system.activationScripts.homebrewBundle.text = ''
    echo "homebrew bundle..." >&2
    sudo --set-home --user=${config.system.primaryUser} -- \
    ${cfg.prefix}/bin/brew bundle \
      --cleanup --quiet \
      --file ${brewfile}
  '';
}
