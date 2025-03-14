{ pkgs, ... }@args:
let
  target = "${args.config.self.alfred.syncFolder}/Alfred.alfredpreferences/preferences/local";

  toPlist = args.lib.generators.toPlist { };

  preferences = pkgs.runCommand "alfred-preferences" { } (
    toString (
      args.lib.mapAttrsToList (name: value: ''
        mkdir -p $out/${name}
        printf %s ${args.lib.escapeShellArg (toPlist value)} > $out/${name}/prefs.plist
      '') args.config.self.alfred.preferences
    )
  );

  helper = ".local/nix/alfred/alfred-preferences";
in
{
  home.file.${helper}.source = pkgs.writeShellScript "alfred-preferences" ''
    for pref_dir in ${args.lib.escapeShellArg target}/*/; do
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
      ProgramArguments = [ "${args.config.home.homeDirectory}/${helper}" ];
    };
  };
}
