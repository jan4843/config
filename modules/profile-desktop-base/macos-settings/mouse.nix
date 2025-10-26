{
  home-manager =
    let
      disableForceClick = "ForceSuppressed";
      lookup = "ActuateDetents";
      tapToClick = "Clicking";

      enabled = 1;
      disabled = 0;
    in
    {
      targets.darwin.defaults."NSGlobalDomain" = {
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleShowScrollBars = "WhenScrolling";
      };

      targets.darwin.defaults."com.apple.AppleMultitouchMouse" = {
        MouseButtonMode = "TwoButton";
        MouseOneFingerDoubleTapGesture = enabled;
      };

      targets.darwin.defaults."com.apple.AppleMultitouchTrackpad" = {
        ${disableForceClick} = true;
        ${lookup} = disabled;
        ${tapToClick} = true;
        TrackpadThreeFingerDrag = true;
      };
    };
}
