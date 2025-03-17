{ pkgs, ... }@args:
let
  conf = {
    ids = {
      "046d:b377" = "";
    };

    main = {
      capslock = "layer(mac_ctrl)";
      leftcontrol = "layer(mac_ctrl)";
      leftmeta = "overload(mac_opt, noop)";
      leftalt = "layer(mac_cmd)";
      altgr = "layer(mac_cmd)";
      rightcontrol = "layer(mac_right_opt)";
    };

    "mac_cmd:C" = {
      c = "C-insert";
      v = "S-insert";
      x = "S-delete";

      left = "home";
      right = "end";
      up = "C-home";
      down = "C-end";

      backspace = "C-S-backspace";

      grave = "A-f6";
      m = "M-h";
      q = "A-f4";

      space = "search";

      tab = "swapm(app_switch_state, M-tab)";
    };

    "app_switch_state:M" = {
      tab = "M-tab";
      right = "M-tab";
      left = "M-S-tab";
    };

    "mac_opt:A" = {
      backspace = "C-backspace";
      left = "C-left";
      right = "C-right";
    };

    "mac_right_opt:G" = {
      backspace = "C-backspace";
      left = "C-left";
      right = "C-right";
    };

    "mac_ctrl:C" = {
      left = "M-pageup";
      right = "M-pagedown";
    };
  };

  src = "${args.config.home.homeDirectory}/${args.config.xdg.configFile."keyd/default.conf".target}";
  dest = "/etc/keyd/default.conf";
in
{
  xdg.configFile."keyd/default.conf".text = args.lib.generators.toINI { } conf;

  self.scripts.install.keyd = {
    path = [ pkgs.coreutils ];
    text = ''
      /usr/bin/sudo ln -fs ${src} ${dest}
    '';
  };

  home.packages = [ pkgs.keyd ];

  systemd.user.services.keyd = {
    Unit = {
      X-Restart-Triggers = [ args.config.xdg.configFile."keyd/default.conf".source ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      ExecStart = [ "sudo ${pkgs.keyd}/bin/keyd" ];
    };
  };
}
