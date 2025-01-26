let
  disableForceClick = "ForceSuppressed";
  lookup = "ActuateDetents";
  tapToClick = "Clicking";

  disabled = 0;
in
{
  targets.darwin.defaults."com.apple.AppleMultitouchTrackpad" = {
    ${disableForceClick} = true;
    ${lookup} = disabled;
    ${tapToClick} = true;
    TrackpadThreeFingerDrag = true;
  };
}
