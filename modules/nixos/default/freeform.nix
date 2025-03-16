{ pkgs, ... }@args:
{
  options.self.freeform = args.lib.mkOption {
    type = (pkgs.formats.json { }).type;
  };
}
