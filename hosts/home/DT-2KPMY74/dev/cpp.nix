{ pkgs, ... }:
let
  pkgs' = {
    cmake-mold = pkgs.writeShellScriptBin "cmake-mold" ''exec mold -run cmake "$@"'';
    gcc-ccache = pkgs.writeShellScriptBin "gcc-ccache" ''exec ccache gcc "$@"'';
    gxx-ccache = pkgs.writeShellScriptBin "g++-ccache" ''exec ccache g++ "$@"'';
  };
in
{
  home.packages =
    [ ]
    ++ (with pkgs'; [
      cmake-mold
      gcc-ccache
      gxx-ccache
    ])
    ++ (with pkgs; [
      ccache
      clang-tools
      cmake
      gcc15
      glibc
      gnumake
      mold
    ])
    ++ (with pkgs.unstable; [
      jetbrains.clion
    ]);
}
