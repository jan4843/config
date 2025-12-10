{ pkgs, ... }:
let
  inputs' = {
    nixpkgs-25-05 = builtins.getFlake "github:NixOS/nixpkgs/00d2457e2f608b4be6fe8b470b0a36816324b0ae";
  };

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
      gcc15
      glibc
      gnumake
      jetbrains.clion
      mold
    ])
    ++ (with inputs'.nixpkgs-25-05.legacyPackages.${pkgs.stdenv.hostPlatform.system}; [
      cmake
    ]);
}
