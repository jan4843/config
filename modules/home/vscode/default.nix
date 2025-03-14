{ pkgs, ... }@args:
let
  types.json = (pkgs.formats.json { }).type;
in
{
  options.self.vscode = {
    keybindings = args.lib.mkOption {
      type = args.lib.types.listOf types.json;
      default = [ ];
    };

    settings = args.lib.mkOption {
      type = types.json;
      default = { };
    };

    tasks = args.lib.mkOption {
      type = args.lib.types.listOf types.json;
      default = [ ];
    };

    snippets = {
      global = args.lib.mkOption {
        type = types.json;
        default = { };
      };

      languages = args.lib.mkOption {
        type = args.lib.types.attrsOf types.json;
        default = { };
      };
    };

    extensions = args.lib.mkOption {
      type = args.lib.types.listOf args.lib.types.str;
      default = [ ];
    };
  };
}
