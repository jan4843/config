{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.stateVersion = "24.11";

  imports = with inputs.self.homeModules; [
    default

    bash
    git
    gnu-utils
    ips
    nix
    tree
    vim
    vscode-config
    wget
  ];

  home.packages = with pkgs; [
    htop
    unar
  ];

  self.vscode.settings."window.titleBarStyle" = "custom";

  targets.genericLinux.enable = true;

  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
    };

    "org/gnome/desktop/privacy" = {
      recent-files-max-age = lib.hm.gvariant.mkUint32 30;

      remove-old-trash-files = true;
      remove-old-temp-files = true;
      old-files-age = lib.hm.gvariant.mkUint32 30;
    };

    "org/gnome/mutter" = {
      experimental-features = [
        "x11-randr-fractional-scaling"
        "scale-monitor-framebuffer"
      ];
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };

    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
  };
}
