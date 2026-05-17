{
  self.homebrew.casks = [ "brave-browser" ];

  targets.darwin.defaults."com.brave.Browser" = {
    NSUserKeyEquivalents = {
      "Pin Tab" = "@k";
      "Duplicate Tab" = "@~t";
    };
  };
}
