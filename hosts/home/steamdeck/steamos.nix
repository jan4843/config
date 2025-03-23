{
  home.username = "deck";
  home.homeDirectory = "/home/deck";

  programs.bash.initExtra = ''
    __steamos_prompt_command() { :; }
  '';
}
