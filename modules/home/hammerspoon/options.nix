{ lib, ... }:
{
  options.self.hammerspoon = {
    spoons = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };
  };
}
