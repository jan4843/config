{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = with inputs.self.homeModules; [
    steam-shortcuts
  ];

  home.packages = with pkgs; [
    protontricks
  ];

  self.bash.functions.__steamos_prompt_command = ":";

  self.backup.paths = [
    "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/*/pfx/drive_c/users"
  ];
}
