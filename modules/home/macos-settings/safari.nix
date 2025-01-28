{
  config,
  lib,
  pkgs,
  ...
}:
let
  db = "${lib.escapeShellArg config.home.homeDirectory}/Library/Safari/PerSitePreferences.db";
in
{
  targets.darwin.defaults."com.apple.Safari" = {
    AutoOpenSafeDownloads = false;
    ShowFullURLInSmartSearchField = true;
    ShowOverlayStatusBar = true;
    AllowJavaScriptFromAppleEvents = true;
    FindOnPageMatchesWordStartsOnly = true;

    CanPromptForPushNotifications = false;

    IncludeDevelopMenu = true;
    WebKitDeveloperExtrasEnabledPreferenceKey = true;
    "WebKitPreferences.developerExtrasEnabled" = true;
  };

  targets.darwin.defaults."com.apple.Safari.SandboxBroker" = {
    ShowDevelopMenu = true;
  };

  self.scripts.write.darwin-settings-safari = {
    path = [ pkgs.sqlite ];
    text = ''
      if sqlite3 ${db} 'SELECT 1 FROM default_preferences' &>/dev/null; then
        sqlite3 ${db} "
          INSERT OR REPLACE INTO default_preferences (preference, default_value) VALUES
            ('PerSitePreferencesCamera', 1),
            ('PerSitePreferencesMicrophone', 1),
            ('PerSitePreferencesStoreKeyScreenCapture', 1),
            ('PerSitePreferencesGeolocation', 1),
            ('PerSitePreferencesDownloads', 0);
        "
      fi
    '';
  };
}
