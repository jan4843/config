{ lib, pkgs, ... }:
let
  types.json = (pkgs.formats.json { }).type;
in
{
  options.self.vscode = {
    keybindings = lib.mkOption {
      type = lib.types.listOf types.json;
      default = [ ];
    };

    settings = lib.mkOption {
      type = types.json;
      default = { };
    };

    tasks = lib.mkOption {
      type = lib.types.listOf types.json;
      default = [ ];
    };

    snippets = {
      global = lib.mkOption {
        type = types.json;
        default = { };
      };

      languages = lib.mkOption {
        type = lib.types.attrsOf types.json;
        default = { };
      };
    };

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };
}
