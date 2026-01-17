{
  self.homebrew.casks = [ "lookaway" ];

  self.open-at-login.lookaway.appPath = "/Applications/LookAway.app";

  targets.darwin.defaults."com.mysticalbits.lookaway" =
    let
      sec = 1;
      min = 60;
      iconOnly = 0;
    in
    {
      SUEnableAutomaticChecks = false;
      SUHasLaunchedBefore = true;
      hasCompletedOnboarding = true;
      analyticsEnabled = false;

      menuBarDisplayOption = iconOnly;

      focusTime = 20 * min;
      reminderThresholdDuration = 5 * sec;
      breakTime = 20 * sec;
      isLongBreakEnabled = false;
      startChimeEnabled = true;
      showSkipAfterDelay = false;
      showActiveAfterIdleNotification = false;

      activitesToTrack = [ ];

      postureReminderEnabled = false;

      hideBreakText = true;
      backgroundBlur = false;
    };
}
