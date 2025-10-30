inputs:
let
  lib' = {
    pipe = builtins.foldl' (x: f: f x);

    flatten =
      xs: builtins.foldl' (acc: x: acc ++ (if builtins.isList x then lib'.flatten x else [ x ])) [ ] xs;

    contains = infix: string: builtins.length (builtins.split infix string) > 1;

    mapDir =
      fn: dir:
      lib'.pipe dir [
        builtins.readDir
        builtins.attrNames
        (map (name: {
          inherit name;
          value = fn name /.${dir}/${name};
        }))
        builtins.listToAttrs
      ];

    findNixFilesRec =
      dir:
      lib'.pipe dir [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (file: !lib'.contains "^\\." file))
        (map (
          file:
          if builtins.pathExists "${dir}/${file}/" then
            lib'.findNixFilesRec "${dir}/${file}"
          else
            "${dir}/${file}"
        ))
        lib'.flatten
        (builtins.filter (path: lib'.contains "\.nix$" (builtins.baseNameOf path)))
      ];
  };

  inputs' =
    let
      filter =
        platform:
        lib'.pipe inputs [
          builtins.attrNames
          (builtins.filter (name: lib'.contains "_${platform}$" name || !lib'.contains "_" name))
          (map (name: {
            name = builtins.replaceStrings [ "_${platform}" ] [ "" ] name;
            value = inputs.${name};
          }))
          builtins.listToAttrs
        ];
    in
    {
      darwin = filter "darwin";
      linux = filter "linux";
    };

  mkApps =
    fn:
    lib'.pipe
      [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ]
      [
        (map (
          system:
          let
            input = "nixpkgs_${if lib'.contains "darwin" system then "darwin" else "linux"}";
            pkgs = inputs.${input}.legacyPackages.${system};
            args = {
              inherit pkgs;
              inherit (pkgs) lib;
            };
          in
          {
            name = system;
            value = builtins.mapAttrs (name: out: {
              type = "app";
              program = "${
                pkgs.writeShellApplication {
                  inherit name;
                  runtimeInputs = out.path;
                  text = out.text;
                }
              }/bin/${name}";
            }) (fn args);
          }
        ))
        builtins.listToAttrs
      ];

  mkModule =
    type: file:
    let
      expr = import file;
    in
    if
      builtins.attrNames (
        {
          nixos = { };
          nix-darwin = { };
          home-manager = { };
        }
        // expr
      ) != [
        "home-manager"
        "nix-darwin"
        "nixos"
      ]
    then
      abort "Invalid attributes (${toString (builtins.attrNames expr)}) in module ${file}"
    else
      {
        _file = file;
        key = file;
        imports = if expr ? ${type} then [ expr.${type} ] else [ ];
      };

  mkModules =
    type: root:
    lib'.pipe root [
      builtins.readDir
      builtins.attrNames
      (map (
        dir:
        let
          nixFiles = lib'.pipe "${root}/${dir}" [
            builtins.readDir
            builtins.attrNames
            (builtins.filter (name: lib'.contains "\.nix$" name))
          ];
        in
        {
          name = dir;
          value =
            if nixFiles == [ ] then
              mkModules type "${root}/${dir}"
            else
              {
                imports = lib'.pipe "${root}/${dir}" [
                  lib'.findNixFilesRec
                  (map (mkModule type))
                  (builtins.filter (x: x.imports != [ ]))
                ];
              };
        }
      ))
      builtins.listToAttrs
    ];
in
{
  nixosModules = mkModules "nixos" ./modules;
  darwinModules = mkModules "nix-darwin" ./modules;
  homeModules = mkModules "home-manager" ./modules;

  nixosConfigurations = lib'.mapDir (
    host: path:
    inputs'.linux.nixpkgs.lib.nixosSystem {
      specialArgs.inputs = inputs'.linux;
      modules = lib'.findNixFilesRec path ++ [ { networking.hostName = host; } ];
    }
  ) ./hosts/nixos;

  darwinConfigurations = lib'.mapDir (
    host: path:
    inputs'.darwin.nix-darwin.lib.darwinSystem {
      specialArgs.inputs = inputs'.darwin;
      modules = lib'.findNixFilesRec path ++ [ { networking.hostName = host; } ];
    }
  ) ./hosts/darwin;

  homeConfigurations = lib'.mapDir (
    name: path:
    let
      expr = import path;
      eval = if builtins.isFunction expr then expr (builtins.functionArgs expr) else expr;
      system = eval.nixpkgs.hostPlatform;
    in
    inputs'.linux.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs.inputs = inputs'.linux;
      pkgs = inputs'.linux.nixpkgs.legacyPackages.${system};
      modules = lib'.findNixFilesRec path ++ [
        {
          options.nixpkgs.hostPlatform = inputs'.linux.nixpkgs.lib.mkOption {
            apply = inputs'.linux.nixpkgs.lib.systems.elaborate;
          };
        }
      ];
    }
  ) ./hosts/home;

  apps = mkApps (
    { pkgs, ... }:
    {
      update = {
        path = with pkgs; [
          coreutils
          curl
          gawk
          gnugrep
          gnused
        ];
        text = ''
          { grep -Eo 'github:.+latest=true' flake.nix || :; } |
          while read -r old; do
            user=''${old#"github:"}; user=''${user%%"/"*}
            repo=''${old#"github:$user/"}; repo=''${repo%%"/"*}
            query=''${old#*"?"}
            version=$(
              curl -sI "https://github.com/$user/$repo/releases/latest" |
              awk -F/ '/^[Ll]ocation:/{print $NF}' |
              tr -d '\r'
            )
            new="github:$user/$repo/$version?$query"
            sed -i.bak "s|$old|$new|g" flake.nix
            rm flake.nix.bak
          done
          nix flake update
        '';
      };
    }
  );

  packages = {
    aarch64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.aarch64-linux.nixos-rebuild;
    x86_64-linux.nixos-rebuild = inputs.nixpkgs_linux.legacyPackages.x86_64-linux.nixos-rebuild;

    aarch64-darwin.darwin-rebuild = inputs.nix-darwin_darwin.packages.aarch64-darwin.darwin-rebuild;

    aarch64-linux.home-manager = inputs.home-manager_linux.packages.aarch64-linux.home-manager;
    x86_64-linux.home-manager = inputs.home-manager_linux.packages.x86_64-linux.home-manager;
  };
}
