{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "copy-secrets";
  text = builtins.readFile ./copy-secrets.bash;
}
