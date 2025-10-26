{
  home-manager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.tmux ];

      home.file.".tmux.conf".text = ''
        set-option -g base-index 1
        set-option -g mode-keys vi
        set-option -g mouse on
        set-option -g pane-base-index 1
        set-option -g renumber-windows on
        set-option -g status-left-length 16
        set-option -g status-right ""

        bind-key -T copy-mode-vi WheelDownPane if-shell -F "#{alternate_on}" "" "select-pane \; send-keys -X scroll-down"
        bind-key -T copy-mode-vi WheelUpPane   if-shell -F "#{alternate_on}" "" "select-pane \; send-keys -X scroll-up"
        bind-key \" split-window -v -c "#{pane_current_path}"
        bind-key %  split-window -h -c "#{pane_current_path}"
        bind-key c new-window -c "#{pane_current_path}"
        bind-key k send-keys C-l \; run-shell ":" \; clear-history
      '';
    };
}
