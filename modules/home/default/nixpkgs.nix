args: args.lib.mkIf (!args ? osConfig) { nixpkgs.config.allowUnfree = true; }
