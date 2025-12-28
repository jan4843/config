{ inputs, lib, ... }:
let
  mkOptionType =
    type:
    lib.mkOptionType {
      name = type;
      check = x: x.type or null == type;
    };
in
{
  options.ois.homebrew = {
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
      type = lib.types.listOf (mkOptionType "brew");
      default = [ ];
    };

    casks = lib.mkOption {
      type = lib.types.listOf (mkOptionType "cask");
      default = [ ];
    };

    mas = lib.mkOption {
      type = lib.types.attrsOf lib.types.ints.unsigned;
      default = { };
    };
  };

  config.ois.homebrew = {
    package = lib.mkDefault inputs.homebrew;
    taps = {
      "homebrew/core" = lib.mkDefault inputs.homebrew-core;
      "homebrew/cask" = lib.mkDefault inputs.homebrew-cask;
    };
  };
}
