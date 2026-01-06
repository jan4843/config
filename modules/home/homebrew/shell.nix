{ config, lib, ... }:
lib.mkIf config.self.homebrew.enable {
  programs.bash.profileExtra = ''
    eval "$(${config.self.homebrew.prefix}/bin/brew shellenv bash)"
  '';

  programs.zsh.profileExtra = ''
    eval "$(${config.self.homebrew.prefix}/bin/brew shellenv zsh)"
  '';

  programs.fish.interactiveShellInit = ''
    eval (${config.self.homebrew.prefix}/brew shellenv fish)
  '';
}
