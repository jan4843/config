args:
let
  findSubdir =
    root: candidates:
    args.lib.pipe candidates [
      (map (subdir: "${root}${subdir}/"))
      (builtins.filter builtins.pathExists)
      builtins.head
    ];

  findItems =
    path:
    args.lib.pipe path [
      builtins.readDir
      builtins.attrNames
      (map (x: "${path}/${x}"))
      (map (x: if builtins.pathExists "${x}/" then findItems x else x))
      args.lib.flatten
    ];

  genItems =
    {
      type,
      subdirs,
      excludes ? [ ],
    }:
    tap:
    args.lib.pipe (findSubdir "${args.config.self.homebrew.taps.${tap}}" subdirs) [
      findItems
      (builtins.filter (args.lib.hasSuffix ".rb"))
      (builtins.filter (
        item:
        !builtins.any (prefix: args.lib.hasPrefix prefix item) (
          map (exclude: "${args.config.self.homebrew.taps.${tap}}/${exclude}/") excludes
        )
      ))
      (map builtins.baseNameOf)
      (map (args.lib.removeSuffix ".rb"))
      (map builtins.unsafeDiscardStringContext)
      (map (name: {
        inherit name;
        value = { inherit type name tap; };
      }))
      builtins.listToAttrs
    ];

  genCasks = genItems {
    type = "cask";
    subdirs = [ "/Casks" ];
  };

  genFormulae = genItems {
    type = "formula";
    subdirs = [
      "/Formula"
      "/HomebrewFormula"
      ""
    ];
    excludes = [
      "/Casks"
      "/cmd"
    ];
  };

  mkOpt =
    type:
    args.lib.mkOption {
      type = args.lib.types.listOf (
        args.lib.mkOptionType {
          name = type;
          check = x: x.type or "" == type;
        }
      );
    };

  mkTaps = builtins.mapAttrs (
    name: tap: {
      __toString = _: tap.outPath;

      casks = genCasks name;
      formulae = genFormulae name;
    }
  );
in
{
  options.self.homebrew = {
    prefix = args.lib.mkOption {
      type = args.lib.types.path;
      default = "/opt/homebrew";
      readOnly = true;
    };

    taps = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.pathInStore;
      apply = mkTaps;
    };

    brews = mkOpt "formula";

    casks = mkOpt "cask";

    mas = args.lib.mkOption {
      type = args.lib.types.attrsOf args.lib.types.ints.unsigned;
      default = { };
    };
  };
}
