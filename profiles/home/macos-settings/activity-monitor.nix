let
  sec = 1;
  allProcesses = 100;
in
{
  targets.darwin.defaults."com.apple.ActivityMonitor" = {
    UpdatePeriod = 1 * sec;
    ShowCategory = allProcesses;
  };
}
