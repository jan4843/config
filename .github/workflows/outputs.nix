let
  # https://docs.github.com/en/actions/reference/runners/github-hosted-runners
  github.runners = {
    aarch64-darwin = "macos-15";
    aarch64-linux = "ubuntu-24.04-arm";
    x86_64-linux = "ubuntu-24.04";
  };

  flake = builtins.getFlake (toString ./../..);
  output =
    key: closure:
    (name: value: {
      name = name;
      closure = ".#${key}.${builtins.toJSON name}.${closure}";
      runner = github.runners.${value.config.nixpkgs.hostPlatform.system};
    });
  outputs =
    key: closure: builtins.attrValues (builtins.mapAttrs (output key closure) (flake.${key} or { }));
in
[ ]
++ outputs "darwinConfigurations" "config.system.build.toplevel"
++ outputs "nixosConfigurations" "config.system.build.toplevel"
++ outputs "homeConfigurations" "activationPackage"
