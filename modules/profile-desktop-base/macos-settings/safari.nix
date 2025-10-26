{
  home-manager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      db = "${config.home.homeDirectory}/Library/Safari/PerSitePreferences.db";
    in
    lib.mkIf pkgs.hostPlatform.isDarwin {
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

      home.activation.setSafariPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if ${pkgs.sqlite}/bin/sqlite ${lib.escapeShellArg db} 'SELECT 1 FROM default_preferences' &>/dev/null; then
          ${pkgs.sqlite}/bin/sqlite ${lib.escapeShellArg db} "
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
