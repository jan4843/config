{ pkgs, ... }:
{
  home.packages = [ pkgs.asdf-vm ];

  home.file.".asdfrc".text = ''
    legacy_version_file = yes
  '';

  self.bash.profile = ''
    . ${pkgs.asdf-vm}/share/bash-completion/completions/asdf.bash
  '';

  self.git.ignore = [ ".tool-versions" ];
}
