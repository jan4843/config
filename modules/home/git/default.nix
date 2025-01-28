{
  config,
  lib,
  pkgs,
  ...
}:
let
  hookScript =
    name: hooks:
    pkgs.writeShellApplication {
      inherit name;
      text = lib.concatLines (builtins.attrValues hooks);
    };

  hooksEnv = pkgs.buildEnv {
    name = "hooks";
    paths = lib.attrsets.mapAttrsToList hookScript config.self.git.hooks;
    pathsToLink = [ "/bin" ];
  };
in
{
  home.packages = [ pkgs.git ];

  home.file = {
    ".config/git/config".text = lib.generators.toGitINI config.self.git.config;
    ".config/git/ignore".text = lib.concatLines config.self.git.ignore;
    ".config/git/hooks".source = "${hooksEnv}/bin";
  };

  programs.bash.initExtra = ''
    . ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
  '';
}
