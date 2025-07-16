args:
let
  services = import ./.files/services.nix args.config.home.homeDirectory;
in
{
  options.self.tcc = builtins.mapAttrs (
    _: _:
    args.lib.mkOption {
      type = args.lib.types.listOf args.lib.types.path;
      default = [ ];
    }
  ) services;
}
