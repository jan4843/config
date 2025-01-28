let
  color = 1;
in
{
  targets.darwin.defaults."com.apple.widgets" = {
    widgetAppearance = color;
  };
}
