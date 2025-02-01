{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.file = lib.mapAttrs' (name: cfg: {
    name = ".nix/steam-shortcuts/${name}";
    value.source = pkgs.writeScript name cfg.script;
  }) config.self.steam-shortcuts;

  self.scripts.write.steam-shortcuts = {
    path = [ (pkgs.python3.withPackages (p: [ p.vdf ])) ];
    text = toString [
      "python"
      ./files/steam-shortcuts.py
      (pkgs.writers.writeJSON "shortcuts.json" (
        lib.mapAttrs' (name: cfg: {
          inherit name;
          value = cfg // {
            script = "${config.home.homeDirectory}/.nix/steam-shortcuts/${name}";
          };
        }) config.self.steam-shortcuts
      ))
    ];
  };
}
