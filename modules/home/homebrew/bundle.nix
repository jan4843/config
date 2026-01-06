{ config, lib, ... }:
let
  cfg = config.self.homebrew;

  taps = map (x: ''tap "${x}"'') (builtins.attrNames cfg.taps);
  brews = map (x: ''brew "${x}"'') cfg.brews;
  casks = map (x: ''cask "${x}", greedy: true'') cfg.casks;

  brewfile = builtins.toFile "Brewfile" ''
    cask_args no_quarantine: true
    ${lib.concatLines (taps ++ brews ++ casks)}
  '';
in
lib.mkIf config.self.homebrew.enable {
  home.activation.homebrewBundle =
    lib.hm.dag.entryBetween [ "installPackages" ] [ "writeBoundary" "homebrewTaps" ]
      ''
        ${cfg.prefix}/bin/brew bundle \
          --cleanup --quiet \
          --file ${brewfile}
      '';
}
