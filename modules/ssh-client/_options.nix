{
  home-manager =
    { lib, ... }:
    {
      options.self.ssh-client = {
        config = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
      };
    };
}
