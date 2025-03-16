args: {
  self.freeform.homebridge = {
    node.version = "20.7.0";
    packages.npm = [ "homebridge@1.7.0" ];

    compose.services.homebridge = {
      build = {
        context = "/var/empty";
        dockerfile_inline = ''
          FROM node:${args.config.self.freeform.homebridge.node.version}
          RUN \
            apt-get update && \
            apt-get install -y ${args.lib.escapeShellArgs args.config.self.freeform.homebridge.packages.apt} && \
            rm -rf /var/lib/apt/lists/*
          RUN \
            npm install --global ${args.lib.escapeShellArgs args.config.self.freeform.homebridge.packages.npm}
        '';
      };

      init = true;
      command = [
        "homebridge"
        "--user-storage-path=/data"
      ];
      restart = "unless-stopped";

      volumes = [
        {
          type = "bind";
          source = "${args.config.self.freeform.homebridge.dataDir}/homebridge";
          target = "/data";
          bind.create_host_path = true;
        }
      ];
    };
  };
}
