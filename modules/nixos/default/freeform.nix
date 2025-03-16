{ pkgs, ... }@args:
{
  options.self.freeform = args.lib.mkOption {
    type = args.lib.types.attrsOf (pkgs.formats.json { }).type;
  };
}
