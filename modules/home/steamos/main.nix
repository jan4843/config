{ pkgs, ... }@args:
{
  imports = with args.inputs.self.homeModules; [
    steam-shortcuts
  ];

  home.packages = with pkgs; [
    protontricks
  ];

  self.bash.functions.__steamos_prompt_command = ":";

  self.backup.paths = [
    "${args.config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/*/pfx/drive_c/users"
  ];
}
