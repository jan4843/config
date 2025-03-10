{ pkgs, ... }:
{
  self.compose.projects.dufs.services.dufs = {
    image = "scratch";
    build = {
      context = pkgs.emptyDirectory;
      dockerfile_inline = "FROM scratch";
    };

    command = [
      "${pkgs.dufs}/bin/dufs"
      "--hidden=.*"
      "--allow-all"
      "/data"
    ];

    volumes = [
      rec {
        type = "bind";
        source = "/nix/store";
        target = source;
        read_only = true;
      }
      {
        type = "bind";
        source = "/srv";
        target = "/data";
      }
    ];

    ports = [ "5000:5000" ];

    restart = "unless-stopped";
  };
}
