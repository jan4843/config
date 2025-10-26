{
  home-manager =
    let
      showDesktop = 4;
      none = 0;
      default = -1;
    in
    {
      targets.darwin.defaults."com.apple.dock" = {
        tilesize = default;
        size-immutable = true;
        mineffect = "scale";

        orientation = "bottom";

        autohide = true;
        autohide-delay = 0;
        autohide-time-modifier = 0.3;

        show-recent-count = 1;

        mru-spaces = false;
        wvous-bl-corner = showDesktop;
        wvous-bl-modifier = none;
        wvous-br-corner = showDesktop;
        wvous-br-modifier = none;
      };
    };
}
