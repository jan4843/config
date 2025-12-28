let
  ms = 15;
  tabNavigation = 3;
in
{
  homeConfig = {
    targets.darwin.defaults."NSGlobalDomain" = {
      KeyRepeat = 30 / ms;
      InitialKeyRepeat = 225 / ms;

      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;

      AppleKeyboardUIMode = tabNavigation;

      ApplePressAndHoldEnabled = false;
    };
  };
}
