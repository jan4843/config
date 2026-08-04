{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains.idea-oss
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "idea-oss-2025.3.4"
  ];
}
