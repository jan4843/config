{ config, lib, ... }:
let
  readDirRecusive =
    dir:
    lib.pipe dir [
      builtins.readDir
      builtins.attrNames
      (map (x: "${dir}/${x}"))
      (map (x: if builtins.pathExists "${x}/" then readDirRecusive x else x))
      lib.flatten
      (map builtins.toPath)
    ];

  findFormulae =
    {
      inFirstExistingDirOutOf,
      butNotInDir ? [ ],
    }:
    tap:
    lib.pipe inFirstExistingDirOutOf [
      (map (dir: "${tap}/${dir}"))
      (builtins.filter builtins.pathExists)
      (
        dirs:
        if dirs == [ ] then
          [ ]
        else
          lib.pipe dirs [
            builtins.head
            readDirRecusive
            (builtins.filter (lib.hasSuffix ".rb"))
            (map (lib.removePrefix "${tap}"))
            (builtins.filter (f: !builtins.any (p: lib.hasPrefix p f) butNotInDir))
            (map builtins.baseNameOf)
            (map (lib.removeSuffix ".rb"))
            (map builtins.unsafeDiscardStringContext)
          ]
      )
    ];

  findBrews = findFormulae {
    inFirstExistingDirOutOf = [
      "/Formula/"
      "/HomebrewFormula/"
      "/"
    ];
    butNotInDir = [
      "/Casks/"
      "/cmd/"
    ];
  };

  findCasks = findFormulae { inFirstExistingDirOutOf = [ "/Casks/" ]; };

  getAllFormatted =
    type:
    lib.pipe config.self.homebrew.taps [
      (lib.mapAttrs (
        tapName: tap:
        lib.pipe tap [
          (
            if type == "brew" then
              findBrews
            else if type == "cask" then
              findCasks
            else
              throw "unreachable"
          )
          (map (
            formula:
            if type == "brew" && tapName == "homebrew/core" then
              formula
            else if type == "cask" && tapName == "homebrew/cask" then
              formula
            else
              "${tapName}/${formula}"
          ))
        ]
      ))
      builtins.attrValues
      lib.flatten
    ];
in
lib.mkIf config.self.homebrew.enable {
  assertions =
    [ ]
    ++ (map (brew: {
      assertion = builtins.elem brew (getAllFormatted "brew");
      message = "Invalid config.self.homebrew.brews = [ ${lib.strings.escapeNixString brew} ]";
    }) config.self.homebrew.brews)
    ++ (map (cask: {
      assertion = builtins.elem cask (getAllFormatted "cask");
      message = "Invalid config.self.homecask.casks = [ ${lib.strings.escapeNixString cask} ]";
    }) config.self.homebrew.casks);
}
