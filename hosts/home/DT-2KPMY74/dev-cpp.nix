{ lib, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "cmake-mold" ''exec mold -run cmake "$@"'')
    (pkgs.writeShellScriptBin "gcc-ccache" ''exec ccache gcc "$@"'')
    (pkgs.writeShellScriptBin "g++-ccache" ''exec ccache g++ "$@"'')
  ]
  ++ (with pkgs; [
    (lib.self.pkgEnsuringVersion llvmPackages_20.clang-tools (v: "20.1" == lib.versions.majorMinor v)) # clang-format-linter
    ccache
    glibc
    gnumake
    jetbrains.clion
    mold
  ])
  ++ (with pkgs.nixpkgs-25-05; [
    (lib.self.pkgEnsuringVersion cmake (v: "3" == lib.versions.major v))
    (lib.self.pkgEnsuringVersion gcc15 (v: "15.1" == lib.versions.majorMinor v))
  ]);
}
