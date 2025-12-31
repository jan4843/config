{
  config,
  lib,
  pkgs,
  ...
}:
let
  pkgs'.steam-shortcuts = pkgs.writeShellApplication {
    name = "steam-shortcuts";
    runtimeInputs = [ (pkgs.python3.withPackages (p: [ p.vdf ])) ];
    text = ''
      python ${./src/steam-shortcuts.py} "$@"
    '';
  };
  shortcuts = pkgs.writers.writeJSON "shortcuts.json" (
    lib.mapAttrs' (name: cfg: {
      inherit name;
      value = cfg // {
        script = "${config.home.homeDirectory}/.local/nix/steam-shortcuts/${name}";
      };
    }) config.self.steam-shortcuts
  );
in
{
  home.file = lib.mapAttrs' (name: cfg: {
    name = ".local/nix/steam-shortcuts/${name}";
    value.source = pkgs.writeScript name ''
      #!/bin/sh
      ${cfg.script}
    '';
  }) config.self.steam-shortcuts;

  home.activation.writeSteamShortcuts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs'.steam-shortcuts}/bin/steam-shortcuts ${shortcuts}
  '';
}
