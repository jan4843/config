{ pkgs, ... }@args:
{
  options.self.compose = {
    projects = args.lib.mkOption {
      type = args.lib.types.attrsOf (pkgs.formats.json { }).type;
      default = { };
    };
  };
}
