{ pkgs, ... }:
{
  home.file.".config/keyd/default.conf".text = ''
    [ids]

    046d:b377

    [main]

    # ctrl
    leftcontrol = layer(mac_ctrl)

    # opt
    leftmeta = overload(mac_opt, noop)

    # cmd
    leftalt = layer(mac_cmd)

    # spacebar

    # cmd
    altgr = layer(mac_cmd)

    # opt
    rightcontrol = layer(mac_right_opt)

    [mac_cmd:C]

    # clipboard

    c = C-insert
    v = S-insert
    x = S-delete

    left = home
    right = end
    up = C-home
    down = C-end

    backspace = C-S-backspace

    grave = A-f6
    m = M-h
    q = A-f4

    space = search

    tab = swapm(app_switch_state, M-tab)
    [app_switch_state:M]
    tab = M-tab
    right = M-tab
    left = M-S-tab

    [mac_opt:A]

    backspace = C-backspace
    left = C-left
    right = C-right

    [mac_right_opt:G]

    backspace = C-backspace
    left = C-left
    right = C-right

    [mac_ctrl:C]

    left = M-pageup
    right = M-pagedown
  '';

  systemd.user.services.keyd = {
    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      ExecStart = [ "sudo ${pkgs.keyd}/bin/keyd" ];
    };
  };
}
