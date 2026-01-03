let
  sec = 1;
  allProcesses = 100;
in
{
  homeConfig = {
    targets.darwin.defaults."com.apple.ActivityMonitor" = {
      UpdatePeriod = 1 * sec;
      ShowCategory = allProcesses;
    };

    targets.darwin.defaults."com.apple.iCal" = {
      "number of hours displayed" = 24;
    };

    targets.darwin.defaults."com.apple.remindd" = {
      showRemindersAsOverdue = false;
    };

    targets.darwin.defaults."com.apple.TextEdit" = {
      NSShowAppCentricOpenPanelInsteadOfUntitledFile = false;
    };
  };
}
