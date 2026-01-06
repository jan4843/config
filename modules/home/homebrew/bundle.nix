{ config, lib, ... }:
let
  taps = map (x: ''tap "${x}"'') (builtins.attrNames config.self.homebrew.taps);
  brews = map (x: ''brew "${x}"'') config.self.homebrew.brews;
  casks = map (x: ''cask "${x}", greedy: true'') config.self.homebrew.casks;
in
lib.mkIf config.self.homebrew.enable {
  home.activation.homebrewBundle =
    lib.hm.dag.entryBetween [ "installPackages" ] [ "writeBoundary" "homebrewTaps" ]
      ''
        ${config.self.homebrew.prefix}/bin/brew bundle \
          --cleanup --quiet \
          --file ${builtins.toFile "Brewfile" (lib.concatLines (taps ++ brews ++ casks))}
      '';
}
