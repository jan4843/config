{ pkgs, ... }@args:
let
  pkgs' = {
    cmake-mold = pkgs.writeShellScriptBin "cmake-mold" ''
      exec mold -run cmake "$@"
    '';

    gcc-ccache = pkgs.writeShellScriptBin "gcc-ccache" ''
      exec ccache gcc "$@"
    '';

    gxx-ccache = pkgs.writeShellScriptBin "g++-ccache" ''
      exec ccache g++ "$@"
    '';

    gcc-cross = pkgs.writeShellScriptBin "${pkgs.hostPlatform.system}-gnu-gcc" ''
      exec gcc "$@"
    '';

    gxx-cross = pkgs.writeShellScriptBin "${pkgs.hostPlatform.system}-gnu-g++" ''
      exec g++ "$@"
    '';
  };

  pkgs-unstable = import args.inputs.nixpkgs-unstable {
    system = pkgs.hostPlatform.system;
    config = args.nixpkgs.config;
  };
in
{
  imports = with args.inputs.self.homeModules; [
    git
    go
    python
  ];

  home.packages =
    [ ]
    ++ (with pkgs; [
      pkgs'.cmake-mold
      pkgs'.gcc-ccache
      pkgs'.gxx-ccache
      pkgs'.gcc-cross
      pkgs'.gxx-cross

      ccache
      clang-tools
      cmake
      gcc9
      glibc
      gnumake
      mold
      ruby
    ])
    ++ (with pkgs-unstable; [
      jetbrains.clion
      jetbrains.goland
      jetbrains.idea-community
      jetbrains.ruby-mine
    ]);
}
