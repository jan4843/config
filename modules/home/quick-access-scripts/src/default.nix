{ pkgs, ... }:
pkgs.buildGoModule {
  pname = "quickaccessscripts";
  version = "0.1.0";
  src = ./.;
  vendorHash = "sha256-0Qxw+MUYVgzgWB8vi3HBYtVXSq/btfh4ZfV/m1chNrA=";
}
