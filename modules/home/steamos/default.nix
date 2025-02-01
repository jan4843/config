{ config, inputs, ... }:
{
  imports = with inputs.self.homeModules; [
    flatpak
    steam-shortcuts
  ];

  self.bash.functions.__steamos_prompt_command = ":";

  self.backup.paths = [
    "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/*/pfx/drive_c/users"
  ];
}
