{
  config,
  lib,
  pkgs,
  ...
}:
let
  target = "${config.self.alfred.syncFolder}/Alfred.alfredpreferences/preferences/local";

  preferences = pkgs.runCommand "alfred-preferences" { } (
    toString (
      lib.mapAttrsToList (name: value: ''
        mkdir -p $out/${name}
        printf %s ${lib.escapeShellArg (lib.generators.toPlist { } value)} > $out/${name}/prefs.plist
      '') config.self.alfred.preferences
    )
  );

  helper = ".local/nix/alfred/alfred-preferences";
in
{
  home.file.${helper}.source = pkgs.writeShellScript "alfred-preferences" ''
    for pref_dir in ${lib.escapeShellArg target}/*/; do
      [ -e "$pref_dir" ] || continue
      ${pkgs.rsync}/bin/rsync \
        --archive --copy-links --delete \
        ${preferences}/ "$pref_dir/"
    done
  '';

  launchd.agents.alfred-preferences = {
    enable = true;
    config = {
      RunAtLoad = true;
      WatchPaths = [ target ];
      ProgramArguments = [ "${config.home.homeDirectory}/${helper}" ];
    };
  };
}
