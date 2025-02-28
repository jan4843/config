{ lib, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
      speed = -0.75;
    };

    "org/gnome/desktop/privacy" = {
      recent-files-max-age = lib.hm.gvariant.mkUint32 30;
      old-files-age = lib.hm.gvariant.mkUint32 30;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
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

    "org/gnome/shell/extensions/ding" = {
      show-home = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      multi-monitor = true;
    };
  };
}
