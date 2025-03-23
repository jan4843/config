args: {
  imports = [ args.inputs.self.homeModules.backup ];

  self.backup = {
    repositoryFile = builtins.toFile "repo" "/run/media/mmcblk0p1/backup";
    passwordFile = builtins.toFile "pass" "local";
    paths = [
      "${args.config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/*/pfx/drive_c/users"
    ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
      yearly = 999;
    };
  };
}
