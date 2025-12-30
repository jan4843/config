{ config, ... }:
{
  programs.bash.interactiveShellInit = ''
    eval "$(${config.self.homebrew.prefix}/bin/brew shellenv bash)"
  '';

  programs.zsh.interactiveShellInit = ''
    eval "$(${config.self.homebrew.prefix}/bin/brew shellenv zsh)"
  '';

  programs.fish.interactiveShellInit = ''
    eval (${config.self.homebrew.prefix}/brew shellenv fish)
  '';
}
