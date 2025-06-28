{
  targets.darwin.defaults."NSGlobalDomain" = {
    AppleEnableMouseSwipeNavigateWithScrolls = true;
    AppleShowScrollBars = "WhenScrolling";
  };

  targets.darwin.defaults."com.apple.AppleMultitouchMouse" = {
    MouseButtonMode = "TwoButton";
    MouseOneFingerDoubleTapGesture = 1;
  };
}
