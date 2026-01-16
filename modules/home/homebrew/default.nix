{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = inputs.self.lib.siblingsOf ./default.nix;

  options.self.homebrew = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pkgs.stdenv.hostPlatform.isDarwin;
    };

    package = lib.mkOption {
      type = lib.types.pathInStore;
    };

    prefix = lib.mkOption {
      readOnly = true;
      default = "/opt/homebrew";
    };

    taps = lib.mkOption {
      type = lib.types.attrsOf lib.types.pathInStore;
      default = { };
      apply =
        taps:
        builtins.deepSeq (lib.pipe taps [
          builtins.attrNames
          (map (
            tapName:
            if builtins.match "[^/]+/[^/]+" tapName == null || lib.hasInfix "/homebrew-" tapName then
              throw ''
                Invalid tap name ${lib.strings.escapeNixIdentifier tapName}.
                Must be in format "user/repo", without "homebrew-" prefix.
                See https://docs.brew.sh/Taps.
              ''
            else
              tapName
          ))
        ]) taps;
    };

    brews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    casks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf config.self.homebrew.enable {
    self.homebrew = {
      package = lib.mkDefault inputs.homebrew;
      taps = {
        "homebrew/core" = lib.mkDefault inputs.homebrew-core;
        "homebrew/cask" = lib.mkDefault inputs.homebrew-cask;
      };
    };

    programs.bash.profileExtra = ''
      eval "$(${config.self.homebrew.prefix}/bin/brew shellenv bash)"
    '';
  };
}
