{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = with inputs.self.homeModules; [
    backup
    bash-config
    git-config
    gnu-utils
    nix
    tailscale-linux
    tree
    vim
    wget
    yuzu
  ];

  self.bash.functions.__steamos_prompt_command = ":";

  self.backup = {
    repositoryFile = pkgs.writeText "" "/run/media/mmcblk0p1/backup";
    passwordFile = pkgs.writeText "" "local";
    paths = [
      "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/*/pfx/drive_c/users/steamuser"
      "${config.home.homeDirectory}/retrodeck/saves"
      "${config.home.homeDirectory}/retrodeck/states"
    ];
    retention = {
      hourly = 24 * 7;
      daily = 365;
      yearly = 999;
    };
  };

  self.tailscale = {
    tags = [ "edge" ];
    upFlags = [ "--ssh" ];
  };
}
