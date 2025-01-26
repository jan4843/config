{ ... }:
fn: dir:
let
  hasSuffix =
    suffix: content:
    let
      lenSuffix = builtins.stringLength suffix;
      lenContent = builtins.stringLength content;
    in
    (
      (lenContent >= lenSuffix)
      && (builtins.substring (lenContent - lenSuffix) lenContent content) == suffix
    );

  removeSuffix =
    suffix: content:
    if hasSuffix suffix content then
      builtins.substring 0 ((builtins.stringLength content) - (builtins.stringLength suffix)) content
    else
      content;
in
builtins.listToAttrs (
  map (x: {
    name = removeSuffix ".nix" x;
    value = fn "${dir}/${x}";
  }) (builtins.attrNames (builtins.readDir dir))
)
