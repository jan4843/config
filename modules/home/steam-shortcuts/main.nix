{ pkgs, ... }@args:
{
  home.file = args.lib.mapAttrs' (name: cfg: {
    name = ".nix/steam-shortcuts/${name}";
    value.source = pkgs.writeShellScriptBin name cfg.script;
  }) args.config.self.steam-shortcuts;

  self.scripts.write.steam-shortcuts = {
    path = [ (pkgs.python3.withPackages (p: [ p.vdf ])) ];
    text = toString [
      "python"
      ./_bin/steam-shortcuts.py
      (pkgs.writers.writeJSON "shortcuts.json" (
        args.lib.mapAttrs' (name: cfg: {
          inherit name;
          value = cfg // {
            script = "${args.config.home.homeDirectory}/.nix/steam-shortcuts/${name}";
          };
        }) args.config.self.steam-shortcuts
      ))
    ];
  };
}
