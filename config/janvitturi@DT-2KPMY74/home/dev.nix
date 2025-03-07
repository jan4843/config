{ inputs, pkgs, ... }:
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
in
{
  imports = with inputs.self.homeModules; [
    git
    go
    python
  ];

  home.packages = with pkgs; [
    pkgs'.cmake-mold
    pkgs'.gcc-ccache
    pkgs'.gxx-ccache
    pkgs'.gcc-cross
    pkgs'.gxx-cross

    ccache
    cmake
    gcc9
    glibc
    gnumake
    mold

    jetbrains.clion
    jetbrains.goland
    jetbrains.idea-community
  ];
}
