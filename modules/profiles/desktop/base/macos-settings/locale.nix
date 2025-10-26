{
  home-manager = {
    targets.darwin.defaults."NSGlobalDomain" = {
      AppleMetricUnits = true;
      AppleTemperatureUnit = "Celsius";
      AppleLanguages = [ "en-US" ];
      AppleLocale = "en_IT";
    };
  };
}
