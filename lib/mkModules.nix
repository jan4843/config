{ self, ... }:
dir:
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
in
(self.lib.mapDir (path: {
  key = builtins.baseNameOf path;
  imports = builtins.map (f: "${path}/${f}") (
    builtins.filter (f: hasSuffix ".nix" f && f != "options.nix") (
      builtins.attrNames (builtins.readDir path)
    )
  );
}) dir)
// {
  default = {
    key = "default";
    imports = builtins.concatLists (
      builtins.attrValues (
        self.lib.mapDir (
          path:
          builtins.map (f: "${path}/${f}") (
            builtins.filter (f: f == "options.nix" || builtins.baseNameOf path == "default") (
              builtins.attrNames (builtins.readDir path)
            )
          )
        ) dir
      )
    );
  };
}
