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
  options.self.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.git;
    };

    config = lib.mkOption {
      type = lib.types.anything;
      default = [ ];
    };

    ignore = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    hooks = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.path);
      default = { };
    };
  };

  config = lib.mkIf config.self.git.enable {
    home.packages = [ pkgs.git ];

    home.file = {
      ".config/git/config".text = lib.generators.toGitINI config.self.git.config;
      ".config/git/ignore".text = lib.concatLines config.self.git.ignore;
      ".config/git/hooks".source = "${hooksEnv}/bin";
    };

    programs.bash.profileExtra = ''
      . ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
    '';
  };
}
